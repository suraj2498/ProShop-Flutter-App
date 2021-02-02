import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';

import '../Providers/products.dart';
import '../Providers/Product.dart';
// import 'package:flutter/services.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();

  static const routeName = '/edit-product';
}

class _EditProductScreenState extends State<EditProductScreen> {

  final imageURLController = TextEditingController();
  final imageURLFocus = FocusNode();
  final form = GlobalKey<FormState>();
  var editedProduct = Product (id: null, title: '', price: 0, description: '', imageUrl: '');
  String pageTitle;
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '' 
  };
  var isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(isInit){
      // we only use didcahngeDependencies because of the fact that we are use ModalRoute odf context
      final productId = ModalRoute.of(context).settings.arguments as String;

      if(productId != null){
        editedProduct = Provider.of<Products>(context, listen: false).findById(productId);
        // to intialize blank text fields with data
        initValues = {
          'title': editedProduct.title,
          'description': editedProduct.description,
          'price': editedProduct.price.toString(),
          // 'imageUrl': editedProduct.imageUrl 
        };
        imageURLController.text = editedProduct.imageUrl;
        pageTitle = 'Edit Product';
      }
      else {
        pageTitle = 'Add Product';
      }
    }
    isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    imageURLController.dispose();
    imageURLFocus.dispose();
  }

  // On form save
  void saveForm() async {
    final isValid = form.currentState.validate();

    // return if invalid
    if(!isValid)
      return;

    form.currentState.save();
    // imageURLController.text = '';

    setState(() {
      isLoading = true;
    });

    try {

      if(editedProduct.id == null){
        await Provider.of<Products>(context, listen: false).addProduct(editedProduct);
      }
      else {
        await Provider.of<Products>(context, listen: false).updateProduct(editedProduct.id, editedProduct);
      }

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Flushbar(
        message: "Something went wrong please try again",
        icon: Icon(
          Icons.cancel_outlined,
          size: 28.0,
          color: Colors.white,
        ),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: 8,
        backgroundColor: Colors.red,
        margin: EdgeInsets.all(8),
        duration: Duration(seconds: 2),
      ).show(context);
    } finally {

      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();

      if(editedProduct.id != null){
        Flushbar(
          message: "${editedProduct.title} Details Updated Successfully",
          icon: Icon(
            Icons.check,
            size: 28.0,
            color: Colors.white,
          ),
          borderRadius: 8,
          backgroundColor: Colors.green,
          margin: EdgeInsets.all(8),
          duration: Duration(seconds: 2),
        ).show(context);
      }

    } 
    // if(editedProduct.id == null){
    //   // context of the attached widget is available everywhere in the state object
    //   Provider.of<Products>(context, listen: false).addProduct(editedProduct)
    //     .then((_){
    //       setState(() {
    //         isLoading = false;
    //       });
    //       Navigator.of(context).pop();
    //     })
    //     .catchError((error){
    //       setState(() {
    //         isLoading = false;
    //       });
    //       Flushbar(
    //         message: "Something went wrong please try again",
    //         icon: Icon(
    //           Icons.check,
    //           size: 28.0,
    //           color: Colors.lightGreen,
    //         ),
    //         flushbarPosition: FlushbarPosition.TOP,
    //         borderRadius: 8,
    //         backgroundColor: Colors.red,
    //         margin: EdgeInsets.all(8),
    //         duration: Duration(seconds: 2),
    //       ).show(context);
    //     });
    // }
    // else {
    //   Provider.of<Products>(context, listen: false).updateProduct(editedProduct.id, editedProduct);
    //   setState(() {
    //       isLoading = false;
    //   });
    //   Navigator.of(context).pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [BoxShadow(
            color: Colors.black26.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0,0)
          )]
        ),
        child: isLoading ?
        Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
          )
        ) : Form(
          key: form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Product Name',                    
                  ),
                  initialValue: initValues['title'],
                  textInputAction: TextInputAction.next,
                  validator: (value){
                    if(value.isEmpty)
                      return 'Product Must Have a Title'; // String is the error message
                    
                    return null; // no error it is correct
                  },
                  onSaved: (value) {
                    editedProduct = Product (
                      title: value, 
                      price: 0, 
                      description: '', 
                      imageUrl: '',
                      id: editedProduct.id, 
                      isFavorite: editedProduct.isFavorite
                    );
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  initialValue: initValues['price'],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value.isEmpty || double.tryParse(value) == null)
                      return 'Product Must Have a Valid Price'; // String is the error message
                    
                    if(double.parse(value) <= 0)
                      return 'Product Must Have Price Greater Than 0'; // String is the error message

                    return null; // no error it is correct
                  },
                  onSaved: (value) {
                    editedProduct = Product (
                      title: editedProduct.title, 
                      price: double.parse(value), 
                      description: '', 
                      imageUrl: '',
                      id: editedProduct.id, 
                      isFavorite: editedProduct.isFavorite
                    );
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  initialValue: initValues['description'],
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                  minLines: 3,
                  onSaved: (value){
                    editedProduct = Product (
                      title: editedProduct.title, 
                      price: editedProduct.price, 
                      description: value, 
                      imageUrl: '',
                      id: editedProduct.id, 
                      isFavorite: editedProduct.isFavorite
                    );
                  },
                  validator: (value){
                    if(value.isEmpty)
                      return 'Product Must Have a Description'; // String is the error message
                    
                    return null; // no error it is correct
                  }
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      padding: imageURLController.text.isEmpty ? EdgeInsets.all(10) : null,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: imageURLController.text.isEmpty ? Center(
                        child: Text('Enter image URL')
                      ) : Image.network(
                          imageURLController.text, 
                          fit: BoxFit.cover
                      ) 
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: imageURLController,
                        focusNode: imageURLFocus,
                        onChanged: (_){
                          setState(() {});
                        },
                        onFieldSubmitted: (_){
                          imageURLFocus.unfocus();
                          saveForm();
                        },
                        onSaved: (value) {
                          editedProduct = Product (
                            title: editedProduct.title, 
                            price: editedProduct.price, 
                            description: editedProduct.description, 
                            imageUrl: value,
                            id: editedProduct.id, 
                            isFavorite: editedProduct.isFavorite
                          );
                        },
                        validator: (value){
                          // https://i.pinimg.com/originals/57/4a/6b/574a6b67345ee4fb869aa1ce57a2d32d.jpg
                          if(value.isEmpty)
                            return 'Please enter a URL'; // String is the error message
                          if(!value.startsWith('http') && !value.startsWith('https'))
                            return 'Please Enter a Valid URL';
                          if(!value.endsWith('.jpg') && !value.endsWith('.png') && !value.endsWith('.jpeg'))
                            return 'Please Enter a Valid URL';

                          return null; // no error it is correct
                        }
                      ),
                    ),
                  ]
                ),
                SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Submit", style: TextStyle(fontSize: 16),),
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    textColor: Colors.white,
                    elevation: 2,
                    onPressed: saveForm,
                  ),
                )
              ]
            ),
          )
        )
      ),
    );
  }
}