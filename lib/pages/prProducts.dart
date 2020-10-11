import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:santarita/utilities/constans.dart';
import 'package:santarita/mysql_data/Product.dart';
import 'package:santarita/mysql_data/Services.dart';
import 'dart:async';

class prProducts extends StatefulWidget {
  prProducts() : super();
  final String title = 'Productos';
  @override
  _prProductsState createState() => _prProductsState();
}
class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer
          .cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _prProductsState extends State<prProducts> {
  List<Product> _products;
  List<Product> _filterProducts;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _nameController;
  TextEditingController _priceController;
  TextEditingController _costController;
  TextEditingController _searchController;
  TextEditingController _indexController;
  TextEditingController _unitsController;
  int index=0;
  Product _selectedProduct;
  bool _isUpdating;
  String _titleProgress;
  updatePadding() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 40.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10.0,),
          _buildNameProduct(),
          SizedBox(height: 5.0,),
          _buildCostProduct(),
          SizedBox(height: 5.0,),
          _buildPriceProduct(),
          SizedBox(height: 5.0,),
          _buildUnitsProduct(),
          SizedBox(height: 10.0,),
        ],
      ),
    );
  }
  Widget _buildNameProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Producto',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 40.0,
          child: TextField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 10.0),
              prefixIcon: Icon(
                Icons.local_grocery_store,
                color: Colors.white,
              ),
              hintText: 'Nombre',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildCostProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Costo',
          style: kLabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 40.0,
          child: TextField(
            controller: _costController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 10.0),
              prefixIcon: Icon(
                Icons.money_off,
                color: Colors.white,
              ),
              hintText: 'Costo',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildPriceProduct(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Precio',
          style: kLabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 40.0,
          child: TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 10.0),
              prefixIcon: Icon(
                Icons.attach_money,
                color: Colors.white,
              ),
              hintText: 'Precio',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
}
  Widget _buildUnitsProduct(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Unidades para agregar al Stock',
          style: kLabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 40.0,
          child: TextField(
            controller: _unitsController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 10.0),
              prefixIcon: Icon(
                Icons.store,
                color: Colors.white,
              ),
              hintText: 'Unidades',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildSearchProduct(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 0.0),
                Container(
                  alignment: Alignment.center,
                  decoration: kBoxDecorationStyle,
                  height: 40.0,
                  width: 150,
                  child: TextField(
                    controller: _searchController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 0.0,left: 7),
                      hintText: 'Buscar',
                      hintStyle: kHintTextStyle,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,),
              onPressed: () {
                _getSearchProducts();
              },
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.white,
          child: Text(
            'Actualizar',
            style: TextStyle(
              color: Color(0xFF1B5E20),
              letterSpacing: 1.5,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          onPressed: () {
            _updateProduct(_selectedProduct);
          },
        ),

        RaisedButton(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.white,
          child: Text(
            ' Cancelar ',
            style: TextStyle(
              color: Color(0xFFB71C1C),
              letterSpacing: 1.5,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          onPressed: () {
            setState(() {
              _isUpdating = false;
            });
            _clearValues();
          },
        ),
      ],
    );
}
  Widget _buildButtonsTable(){
    return Row(

      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
            children: <Widget>[
              _buildSearchProduct()
            ],
        ),
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //button previous
                IconButton(
                  icon: Icon(
                    Icons.skip_previous,
                    color: Colors.blueGrey,),
                  onPressed: () {
                    _getPrevious();
                  },
                ),
                //textfield number page
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    Container(
                      alignment: Alignment.center,
                      decoration: kBoxDecorationStyle,
                      height: 40.0,
                      width: 30,
                      child: TextField(
                        controller: _indexController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 0.0,left: 7),
                          //hintText: 'Costo',
                          hintStyle: kHintTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    color: Colors.blueGrey,),
                  onPressed: () {
                    _getNext();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }



  final _debouncer = Debouncer(milliseconds: 2000);

  @override
  void initState() {
    super.initState();
    _products = [];
    _filterProducts = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _nameController = TextEditingController();
    _costController = TextEditingController();
    _priceController = TextEditingController();
    _indexController = TextEditingController();
    _searchController = TextEditingController();
    _unitsController = TextEditingController();
    _indexController.text = "${index}";
    _getProducts();
  }
  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }
  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  _getProducts() {
    _showProgress('Cargando productos...');
    Services.getProducts().then((products) {
      setState(() {
        _products = products;
      });
      _showProgress(widget.title);
      setState(() {
        _isUpdating = false;
      });
      _clearValues();
      _indexController.text= '0';
      index=0;
      _searchController.text ='';
      print("total de productos ${products.length}");
    });
  }
  _getPageProducts(String number) {
    _showProgress('Cargando productos...');
    Services.getPageProducts(number).then((products) {
      setState(() {
        _products = products;
      });
      _showProgress(widget.title);
      setState(() {
        _isUpdating = false;
      });
      _clearValues();
      print("total de productos ${products.length}");
    });
  }
  _getPrevious(){
    if(index<=0){
      print("index: ${index}");
      _indexController.text = "${index}";
      _getPageProducts(_indexController.text);
    }else{
      index--;
      print("index: ${index}");
      _indexController.text = "${index}";
      _getPageProducts(_indexController.text);
    }
  }
  _getNext(){
    if(index>=20){
      print("index: ${index}");
      _indexController.text = "${index}";
      _getPageProducts(_indexController.text);
    }else{
      index++;
      print("index: ${index}");
      _indexController.text = "${index}";
      _getPageProducts(_indexController.text);
    }
  }
  _getSearchProducts(){
    print(_searchController.text);
    _showProgress('Buscando productos...');
    Services.getSearchProducts(_searchController.text).then((products) {
      setState(() {
        _products = products;
      });
      _showProgress(widget.title);
      setState(() {
        _isUpdating = false;
      });
      _clearValues();
      print("total de productos ${products.length}");
    });
  }
  _updateProduct(Product product) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Actualizando producto...');
    Services.updateProduct(
        product.code,_costController.text,_priceController.text,_unitsController.text)
        .then((result) {
      if ('success' == result) {
        print('resultado'+result);
        _showProgress('Producto Actualizado...');
        _clearValues();
        if(_searchController.text=='' && index==0){
            print('caso 1');
            _getProducts();
        }else{
          if(_searchController.text!='' && index==0) {
            print('caso 2');
            _getSearchProducts();

          }else{
            print('caso 3');
            _getPageProducts(_indexController.text);
            _searchController.text = '';
          }
        }

      }
    });
  }
  _clearValues() {
    _nameController.text = '';
    _costController.text = '';
    _priceController.text = '';
    _unitsController.text = '';
  }
  _showValues(Product product) {
    _nameController.text = product.name;
    _costController.text = product.cost;
    _priceController.text = product.price;
    _unitsController.text = '0';
  }
  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                  'NOMBRE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                )),
            ),
            DataColumn(
              label: Text(
                  'COSTO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            DataColumn(
              label: Text(
                  'PRECIO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                  )),
            ),DataColumn(
              label: Text(
                  'STOCK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                  )),
            )
          ],
          // the list should show the filtered list now
          rows: _products
              .map(
                (product) => DataRow(cells: [

              DataCell(

                Text(
                  product.name.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  _showValues(product);
                  // Set the Selected employee to Update
                  _selectedProduct = product;
                  // Set flag updating to true to indicate in Update Mode
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
                  DataCell(
                    Text(
                      product.cost.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      _showValues(product);
                      // Set the Selected employee to Update
                      _selectedProduct = product;
                      // Set flag updating to true to indicate in Update Mode
                      setState(() {
                        _isUpdating = true;
                      });
                    },
                  ),

              DataCell(
                Text(
                  product.price.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  _showValues(product);
                  // Set the Selected employee to Update
                  _selectedProduct = product;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
                  DataCell(
                    Text(
                      product.units.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      _showValues(product);
                      // Set the Selected employee to Update
                      _selectedProduct = product;
                      setState(() {
                        _isUpdating = true;
                      });
                    },
                  )
            ]),
          )
              .toList(),
        ),
      ),
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF3F0D16),
        title: Text(_titleProgress), // we show the progress in the title...
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getProducts();
            },
          )
        ],
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF4D101B),
                      Color(0xFF4D101B),
                      Color(0xFF4D101B),
                      Color(0xFF4D101B),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      updatePadding(),
                      _isUpdating ?
                      _buildButtons()
                          : Container(),
                      SizedBox(height: 30,),
                      _buildButtonsTable(),
                      Container(
                        height: 300,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _dataBody()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}