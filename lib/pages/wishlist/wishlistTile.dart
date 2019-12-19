import 'package:flutter/material.dart';

class WishlistTile extends StatelessWidget {
  final Widget leading, title, subtitle, trailing;
  final Function onTap;
  WishlistTile({
    this.leading,
    this.onTap,
    this.subtitle,
    this.title,
    this.trailing,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 2.5,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: EdgeInsets.all(5.0),
          child: Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 50.0,
                    child: leading,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          title,
                          subtitle,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0.0,
                right: 0.0,
                child: trailing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
