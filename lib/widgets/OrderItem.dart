import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Providers/Orders.dart' as OI;

class OrderItem extends StatefulWidget {

  final OI.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with TickerProviderStateMixin {

  var _expanded = false;
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200)
    );

    // _animation = CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.linear,
    // );
    _animation = Tween<double>(
      begin: 0.5,
      end: 0
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: _expanded ? (widget.order.products.length * 30.0 + 110) : 85,
      width: double.infinity, 
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black38.withOpacity(0.2), offset: Offset(0,0), blurRadius: 8)
        ]
      ),
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: [
          ListTile(
            title: Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Text('\$${widget.order.amount.toStringAsFixed(2)}',)
            ),
            subtitle: Text(DateFormat('MM/dd/yyyy, hh:mm').format(widget.order.timeOrdered)),
            trailing: RotationTransition(
              turns: _animation,
              child: IconButton(
                icon: Icon(Icons.expand_less),
                onPressed: (){
                  setState(() {
                    _expanded ? _controller.reverse(): _controller.forward();
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: _expanded ? (widget.order.products.length * 30.0 + 30): 0, 
            child: ListView(
              children: widget.order.products.map((product) => Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.title, style: TextStyle(fontSize: 16),), 
                    Text(
                      '\$ ${product.price.toStringAsFixed(2)} x ${product.quantity}x', 
                      style: TextStyle(
                        fontSize: 16, 
                        color: Colors.grey),
                    )
                  ]
                ),
              )).toList(),
            ),
          )
        ],
      ),
    );
  } 
}