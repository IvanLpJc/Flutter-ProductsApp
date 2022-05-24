import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/products_service.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  static const routeName = 'product';

  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
        //De esta forma siempre tenemos acceso a la instancia del ProductFormProvider
        //cuando estamos en esta pantalla
        //Así también tenemos acceso a el desde la cámara
        create: (_) => ProductFormProvider(productService.selectedProduct),
        child: _ProductScreenBody(productService: productService));
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ProductImage(
                    image: productForm.product.image,
                  ),
                  Positioned(
                      top: 40,
                      left: 30,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 40,
                          color: Colors.white,
                        ),
                      )),
                  Positioned(
                      top: 40,
                      right: 40,
                      child: IconButton(
                        onPressed: () {
                          //TODO Cámara o galería
                        },
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _ProductForm(),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_alt_outlined),
        onPressed: () async {
          if (!productForm.isValidForm()) return;
          await productService.createOrUpdateProduct(productForm.product);
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: _buildBoxDecoration(),
      child: Form(
        key: productForm.formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              onChanged: (value) => product.name = value,
              validator: (value) {
                if (value == null || value.length < 2) {
                  return 'El nombre es obligatorio';
                }
              },
              initialValue: product.name,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto', labelText: 'Nombre:'),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              onChanged: (value) {
                if (double.tryParse(value) == null) {
                  product.price = 0;
                } else {
                  product.price = double.parse(value);
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
              initialValue: '${product.price}',
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '150', labelText: 'Precio (\$):'),
            ),
            const SizedBox(
              height: 30,
            ),
            SwitchListTile.adaptive(
                title: const Text('Disponible'),
                activeColor: Colors.indigo,
                value: product.available,
                onChanged: productForm.updateAvailability)
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 10)
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      );
}
