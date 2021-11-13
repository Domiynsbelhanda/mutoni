import 'package:flutter/material.dart';

Color bgColor = Color(0xffEDF4F9);
Color couleurPrimaire = Color(0xff297EC1);

Widget button(BuildContext context, String text, onTap){
  return Container(
                decoration: BoxDecoration(
                  color: couleurPrimaire,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: TextButton(
                    onPressed: onTap, 
                    child: // Adobe XD layer: 'Hotel Name' (text)
                      Text(
                        '${text}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Colors.white,
                        )
                      )
                  ),
                ),
              );
}