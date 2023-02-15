import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/models.dart';
import 'package:shop/providers/product_provider.dart';

class ProductEditScreen extends StatefulWidget {
  const ProductEditScreen({super.key});
  static const String routeName = '/product-edit';

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  // form.
  final _formKey = GlobalKey<FormState>();
  ProductModel _productFormModel =
      ProductModel(id: '', title: '', description: '', price: 0, imageUrl: '');

  // Nodes.
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  // Controllers.
  final _imageUrlCtrl = TextEditingController();

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        final product = Provider.of<ProductProvider>(context, listen: false)
            .findById(productId);
        _productFormModel = product;
        _imageUrlCtrl.text = _productFormModel.imageUrl ?? '';
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  void _save(BuildContext context, String? productId) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_productFormModel.id == null || _productFormModel.id!.isEmpty) {
      Provider.of<ProductProvider>(context, listen: false)
          .createProduct(_productFormModel);
    } else {
      Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(_productFormModel.id!, _productFormModel);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var productId = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(productId == null ? 'Add Product' : 'Edit Product'),
        actions: [
          IconButton(
              onPressed: () => _save(context, productId as String?),
              icon: const Icon(Icons.save))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _productFormModel.title,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) =>
                        FocusScope.of(context).requestFocus(_priceFocusNode),
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                    validator: (value) {},
                  ),
                  TextFormField(
                    initialValue: _productFormModel.price.toStringAsFixed(2),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (value) => FocusScope.of(context)
                        .requestFocus(_descriptionFocusNode),
                    decoration: const InputDecoration(label: Text('Price')),
                  ),
                  TextFormField(
                    initialValue: _productFormModel.description,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    decoration:
                        const InputDecoration(label: Text('Description')),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                                width: 100,
                                height: 100,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                  child: _productFormModel.imageUrl == null ||
                                          _productFormModel.imageUrl!.isEmpty
                                      ? const Text('data')
                                      : Image.network(
                                          _productFormModel.imageUrl!,
                                          fit: BoxFit.cover),
                                )),
                            const SizedBox(width: 20),
                            Expanded(
                              child: TextFormField(
                                // initialValue: _productFormModel.imageUrl,
                                // You cannot set initial value like this with
                                // controller defined
                                maxLines: 3,
                                controller: _imageUrlCtrl,
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                    label: Text('Image URL')),
                              ),
                            )
                          ]))
                ],
              )),
        ),
      ),
    );
  }
}
