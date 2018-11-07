import 'dart:async';

import 'package:warehouse_mobile/data/rest_ds.dart';
import 'package:warehouse_mobile/model/product.dart';
import 'package:flutter/material.dart';

class ProductDetailsState extends State<ProductDetails> {

	final textEditingController = TextEditingController();

	RestDatasource api = new RestDatasource();

	BuildContext _ctx;

	@override
	void dispose() {
		textEditingController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Product details'),
			),
			body: Builder(
				builder: (BuildContext context) {
					this._ctx = context;
					return ListView(
						children: [_buildProductDetails(), _buildButtonSelectionBar()]);
				})
		);
	}

	Widget _buildProductDetails() {
		return Container(
			padding: const EdgeInsets.all(32.0),
			child: Row(
				children: [
					Expanded(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Container(
									padding: const EdgeInsets.only(bottom: 8.0),
									child: Text(
										widget.product.modelName,
										style: TextStyle(
											fontWeight: FontWeight.bold,
										),
									),
								),
								Text(
									widget.product.manufacturerName,
									style: TextStyle(
										color: Colors.grey[500],
									),
								),
								Text(
									widget.product.price.toString() + widget.product.currency,
									style: TextStyle(
										color: Colors.blue,
									),
								),
							],
						),
					),
					Icon(
						Icons.shopping_cart,
						color: Colors.red[500],
					),
					Text(widget.product.quantity.toString()),
				],
			));
	}

	Widget _buildButtonSelectionBar() {
		return Container(
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
				children: [
					MaterialButton(
						child: buildButtonColumn(Icons.add_circle, 'Add products'),
						onPressed: _addProductsToWarehouse,
					),
					MaterialButton(
						child: buildButtonColumn(Icons.remove_circle, 'Remove products'),
						onPressed: _removeProductsToWarehouse,
					),
					MaterialButton(
						child: buildButtonColumn(Icons.refresh, 'Refresh'),
						onPressed: () {},
					)
				],
			),
		);
	}

	Column buildButtonColumn(IconData icon, String label, [buttonFn]) {
		Color color = Theme
			.of(context)
			.primaryColor;

		return Column(
			mainAxisSize: MainAxisSize.min,
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				Icon(icon, color: color),
				Container(
					margin: const EdgeInsets.only(top: 8.0),
					child: Text(
						label,
						style: TextStyle(
							fontSize: 12.0,
							fontWeight: FontWeight.w400,
							color: color,
						),
					),
				),
			],
		);
	}

	void _addProductsToWarehouse() async {
		int quantity = await _showInputDialog();

		_changeProductsQuantity(quantity);
	}

	void _removeProductsToWarehouse() async {
		int quantity = await _showInputDialog();

		_changeProductsQuantity(-quantity);
	}

	void _changeProductsQuantity(int quantity) async {
		if (quantity != null) {
			bool itemsChanged = await this.api.changeProductItems(
				widget.product, quantity);

			print(itemsChanged);
			if (itemsChanged) {
				Scaffold.of(_ctx).showSnackBar(
					new SnackBar(content: Text('Successfully added products!'))
				);
			} else {
				Scaffold.of(_ctx).showSnackBar(
					new SnackBar(content: Text('Products not added, not enough room!'))
				);
			}
		}
	}

	Future<int> _showInputDialog() async {
		return showDialog<int>(
			context: context,
			builder: (BuildContext context) {
				return new AlertDialog(
					contentPadding: const EdgeInsets.all(20.0),
					content: new Row(children: <Widget>[
						new Expanded(
							child: new TextField(
								autofocus: true,
								decoration: new InputDecoration(
									labelText: 'Quantity', hintText: '2137'),
								keyboardType: TextInputType.number,
								controller: textEditingController,
							))
					]),
					actions: <Widget>[
						new FlatButton(onPressed: () {
							Navigator.pop(context, null);
						}, child: const Text('Cancel')),
						new FlatButton(onPressed: () {
							Navigator.pop(context, int.parse(textEditingController.text));
						}, child: const Text('Send'))
					]);
			});
	}
}

class ProductDetails extends StatefulWidget {
	final Product product;

	ProductDetails({Key key, @required this.product}) : super(key: key);

	@override
	ProductDetailsState createState() => new ProductDetailsState();
}
