import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/providers/productsProvider.dart';

class AddEditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _priceFocusNode =
      FocusNode(); // ds property is created to represent input focus for the price field, it will b passed to the onFieldSubmitted() of the input above the price input in other to b able to move to the price input when the "Enter/Next/Done" on the keyboard is pressed
  final _descriptionFocusNode = FocusNode();
  final _imageURLController =
      TextEditingController(); //we add ds so we can get access to the image url user enters in the img input field so we can use it to show a preview
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<
      FormState>(); // ds property represents and contains our form state
  var _editedProduct = Product(
      id: null,
      title: "",
      description: "null",
      price: 0,
      imageUrl: "",
      isFavorite:
          false); // we setup ds property has an empty product and each of our form field will fill its values with the values of the input fields
  var _isInit =
      true; // we use this to detect when our component is newly loaded
  // We create an object which by default is empty but when the component is loaded, we update it with the product details
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  //we set this to true on form submission async call to the backend
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    //if the component just loaded, we want to update the _editProduct
    if (_isInit) {
      //we retrieve the productId we get from the route arg passed to this screen
      final productId = ModalRoute.of(context).settings.arguments as String;
      // we check first if an id was passed as argument to this component bcos when we click on the add icon on the userProductsScreen, we do not pass any arg, we pass arg only when we click on the edit icon
      if (productId != null) {
        // then we call the findById method of the product provider to get the product
        _editedProduct =
            Provider.of<ProductsProvider>(context).findById(productId);
//      here we update our _initValues object with the product details fetched
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
//          'imageUrl': _editedProduct.imageUrl, we cannot do ds here bcos the imageUrl is using a controller
          'imageUrl': "",
        };
        _imageURLController.text = _editedProduct
            .imageUrl; // we set the initial value for the imageUrl field here
      }
    }
    _isInit = false; //after the component is loaded, we set ds to false
    super.didChangeDependencies();
  }

  //here we dispose our focusNodes when we leave the screen to avoid memory leaks
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    // if the imageURL input field has lost focus but fails any of the validation below, we return doing nothing bcos we do not want to render a preview for an invalid image
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageURLController.text.startsWith("http") &&
              !_imageURLController.text.startsWith("https")) ||
          (!_imageURLController.text.endsWith("jpg") &&
              !_imageURLController.text.endsWith("png") &&
              !_imageURLController.text.endsWith("jpeg"))) {
        return;
      }
      // else we update the state with the image
      //we update the state with the imgURL
      setState(() {});
    }
  }

  // ds method will be called to save our form
  _saveForm() async {
    //we validate all form fields and returns true if there are no errors
    final isValid = _form.currentState.validate();
    // if validator returns false, it means there are errors and we simply want to return
    if (!isValid) {
      return;
    }
    // else if isValid is true, it means there are no errors so we can save the form...
    // we call our form using the _form property we have attached to it and call the save() method
    _form.currentState.save();
//    we set isLoading to true once we start form submission
    setState(() {
      _isLoading = true; //we show loading spinner when submitting our form
    });
    // we run a check maybe we are adding a new product (id will be null) or we are editing an existing product
    //editing
    if (_editedProduct.id != null) {
      await Provider.of<ProductsProvider>(context)
          .updateProduct(_editedProduct.id, _editedProduct);
    }
    //adding
    else {
      //we try to add a product
      try {
        await Provider.of<ProductsProvider>(context).addProduct(_editedProduct);
      }
      // if an error occur, we catch it
      catch (error) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("An Error Occurred!"),
                  content: Text("Something Went Wrong!"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Okay"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
/*      // whether we succeed or fail, we update the state to remove the loader and pop off the current screen
       finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }*/
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body:
          // if we are calling backend, then isLoading is set to true and we render a progress indicator
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  child: Form(
                      key:
                          _form, // we bind our form to the '_form' property we created above
                      child: ListView(
                        children: <Widget>[
                          // TITLE
                          TextFormField(
                            initialValue: _initValues[
                                'title'], // we set our initial values for this field to take the value of the 'title' field of our _initValues object
                            decoration: InputDecoration(
                                labelText:
                                    'Title'), //'labelText' : is our input label
                            //ds describe what the Enter button will do after entering text inside d input, next means it will move to the next input field
                            textInputAction: TextInputAction.next,
                            // ds fires when we click the Enter/Next/Done button on the Title input field and it moves us down to the Price input field using its focusNode property declared above
                            onFieldSubmitted: (inputValue) {
                              FocusScope.of(context)
                                  .requestFocus(_priceFocusNode);
                            },
                            // title field form validation: -  it checks if d input field is empty and return an error message else it returns null which means check is passed
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter A Title";
                              }
                              return null;
                            },
                            // onSaved method of the form will keep all existing values of d form and replace the value of the title field with the user input here
                            onSaved: (value) {
                              _editedProduct = Product(
                                  title: value,
                                  description: _editedProduct.description,
                                  id: _editedProduct.id,
                                  imageUrl: _editedProduct.imageUrl,
                                  price: _editedProduct.price,
                                  isFavorite: _editedProduct.isFavorite);
                            },
                          ),
                          //PRICE
                          TextFormField(
                            initialValue: _initValues['price'],
                            decoration: InputDecoration(labelText: 'Price'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType
                                .number, // d keyboard will display number only bcos we want to enter product price here
                            focusNode:
                                _priceFocusNode, // we set the focus of this input field to the property we created above
                            onFieldSubmitted: (inputValue) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            validator: (value) {
                              //if d price field is empty
                              if (value.isEmpty) {
                                return "Please Enter A Price";
                              }
                              // we try to convert the value to double, that returns null if it fails
                              if (double.tryParse(value) == null) {
                                return "Please Enter A Valid Number";
                              }
                              //zero validation
                              if (double.parse(value) <= 0) {
                                return "Please Enter A Number Greater Than Zero";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  id: _editedProduct.id,
                                  imageUrl: _editedProduct.imageUrl,
                                  price: double.parse(value),
                                  isFavorite: _editedProduct.isFavorite);
                            },
                          ),
                          //DESCRIPTION
                          TextFormField(
                            initialValue: _initValues['description'],

                            decoration:
                                InputDecoration(labelText: 'Description'),
                            maxLines:
                                3, //ds will convert the input field to textArea field for longer text
                            keyboardType: TextInputType
                                .multiline, //ds gives us a keyboard suitable for multiline text so when the Enter/Done button is pressed, it takes d cursor to the next line
                            focusNode: _descriptionFocusNode,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter A Description";
                              }
                              if (value.length < 10) {
                                return "Description Should Be At least 10 Characters";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  title: _editedProduct.title,
                                  description: value,
                                  id: _editedProduct.id,
                                  imageUrl: _editedProduct.imageUrl,
                                  price: _editedProduct.price,
                                  isFavorite: _editedProduct.isFavorite);
                            },
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              //ds container shows d image preview
                              Container(
                                width: 100,
                                height: 100,
                                margin: EdgeInsets.only(top: 8, right: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                                child: _imageURLController.text.isEmpty
                                    ? Text("Enter A URL")
                                    : FittedBox(
                                        child: Image.network(
                                            _imageURLController.text),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Expanded(
                                child: TextFormField(
//                        initialValue: _initValues['imageUrl'], we cannot do ds here bcos we are already using a controller so we set it differently in line
                                  decoration:
                                      InputDecoration(labelText: 'Image URL'),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction
                                      .done, //we add ds bcos its d last input so when we press it, we want to submit the form
                                  controller:
                                      _imageURLController, // u dont need setting up ds with the property above if u do not want to get d value b4 the form is submitted
                                  focusNode: _imageUrlFocusNode,
//                    when the Enter/Done button is clicked after this input, we call the _saveForm() method to save the form
                                  onFieldSubmitted: (value) {
                                    _saveForm();
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please Enter Image URL.";
                                    }
                                    // checking for valid url (a valid url sud start with either http or https
                                    if (!value.startsWith("http") &&
                                        !value.startsWith("https")) {
                                      return "Please Enter A Valid URL.";
                                    }
                                    if (!value.endsWith("jpg") &&
                                        !value.endsWith("png") &&
                                        !value.endsWith("jpeg")) {
                                      return "Please Enter A Valid Image.";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedProduct = Product(
                                        title: _editedProduct.title,
                                        description: _editedProduct.description,
                                        id: _editedProduct.id,
                                        imageUrl: value,
                                        price: _editedProduct.price,
                                        isFavorite: _editedProduct.isFavorite);
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                  padding: EdgeInsets.all(16),
                ),
    );
  }
}
