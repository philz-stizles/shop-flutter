import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/models.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/widgets/widgets.dart';

class ProductEditScreen extends StatefulWidget {
  const ProductEditScreen({super.key});
  static const String routeName = '/product-edit';

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  var _isLoading = false;
  // form.
  final _formKey = GlobalKey<FormState>();
  ProductModel _productFormModel =
      ProductModel(id: '', title: '', description: '', price: 0, imageUrl: '');

  // Nodes.
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imgFocusNode = FocusNode();

  // Controllers.
  final _imageUrlCtrl = TextEditingController();

  var _isInit = true;

  @override
  void initState() {
    _imgFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

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

    _imgFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imgFocusNode.hasFocus) {
      if (_imageUrlCtrl.text.isEmpty ||
          (!_imageUrlCtrl.text.startsWith('http') &&
              !_imageUrlCtrl.text.startsWith('https')) ||
          (!_imageUrlCtrl.text.endsWith('.png') &&
              !_imageUrlCtrl.text.endsWith('jpg') &&
              !_imageUrlCtrl.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

// void _save() {
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    try {
      // setState(() {
      //   _isLoading = true;
      // });
      final navigator = Navigator.of(context);
      LoadingOverlay.of(context).show();
      if (_productFormModel.id == null || _productFormModel.id!.isEmpty) {
        await Provider.of<ProductProvider>(context, listen: false)
            .createProductAsync(_productFormModel);
        navigator.pop({'status': true, 'message': 'Created Successfully'});
      } else {
        await Provider.of<ProductProvider>(context, listen: false)
            .updateProductAsync(_productFormModel.id!, _productFormModel);
        navigator.pop({'status': true, 'message': 'Updated Successfully'});
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('data'),
                content: const Text('Somethig went wrong'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Okay'))
                ],
              ));
    } finally {
      // setState(() {
      //   _isLoading = true;
      // });
      LoadingOverlay.of(context).hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    var productId = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(productId == null ? 'Add Product' : 'Edit Product'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save))],
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
                    onSaved: (newValue) => setState(() {
                      if (newValue != null) {
                        _productFormModel = ProductModel(
                            id: _productFormModel.id,
                            title: newValue,
                            description: _productFormModel.description,
                            price: _productFormModel.price,
                            imageUrl: _productFormModel.imageUrl);
                      }
                    }),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a valid title';
                      }

                      return null;
                    },
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
                    onSaved: (newValue) => setState(() {
                      if (newValue != null) {
                        _productFormModel = ProductModel(
                            id: _productFormModel.id,
                            title: _productFormModel.title,
                            description: _productFormModel.description,
                            price: double.parse(newValue),
                            imageUrl: _productFormModel.imageUrl);
                      }
                    }),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a valid price';
                      }

                      if (double.tryParse(value) == null) {
                        return 'Please provide a valid price';
                      }

                      if (double.parse(value) <= 0) {
                        return 'Please provide a price greater than 0';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _productFormModel.description,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    decoration: const InputDecoration(
                      label: Text('Description'),
                    ),
                    onSaved: (newValue) => setState(() {
                      if (newValue != null) {
                        _productFormModel = ProductModel(
                            id: _productFormModel.id,
                            title: _productFormModel.title,
                            description: newValue,
                            price: _productFormModel.price,
                            imageUrl: _productFormModel.imageUrl);
                      }
                    }),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a valid description';
                      }

                      if (value.length < 10) {
                        return 'Description should be atleast 10 characters long';
                      }

                      return null;
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ImagePreviewCard(imageUrl: _imageUrlCtrl.text),
                            const SizedBox(width: 20),
                            Expanded(
                              child: TextFormField(
                                // initialValue: _productFormModel.imageUrl,
                                // You cannot set initial value like this with
                                // controller defined
                                maxLines: 3,
                                controller: _imageUrlCtrl,
                                focusNode: _imgFocusNode,
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                    label: Text('Image URL')),
                                onSaved: (newValue) => setState(() {
                                  if (newValue != null) {
                                    _productFormModel = ProductModel(
                                        id: _productFormModel.id,
                                        title: _productFormModel.title,
                                        description:
                                            _productFormModel.description,
                                        price: _productFormModel.price,
                                        imageUrl: newValue);
                                  }
                                }),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please provide a valid image URL';
                                  }

                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please provide a valid image URL';
                                  }

                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('jpg') &&
                                      !value.endsWith('jpeg')) {
                                    return 'Please provide a valid image URL';
                                  }

                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  _save();
                                },
                                // onEditingComplete: () {
                                //   setState(() {});
                                // },
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
