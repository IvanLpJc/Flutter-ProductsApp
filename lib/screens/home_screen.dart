import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = 'Home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    if (productsService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (context, index) => GestureDetector(
            child: ProductCard(product: productsService.products[index]),
            onTap: () {
              //Utilizo el service porque en flutter los objetos se pasan por
              //referencia, de modo que si modifico el producto en la pantalla
              //de product, se modificaría en la lista, y yo no quiero modificar
              //hasta que pulso en guardar

              productsService.selectedProduct =
                  productsService.products[index].copy();
              Navigator.pushNamed(context, ProductScreen.routeName);
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
