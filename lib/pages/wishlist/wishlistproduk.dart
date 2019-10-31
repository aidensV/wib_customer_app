import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:wib_customer_app/env.dart';
import 'package:wib_customer_app/storage/storage.dart';

String tokenType, accessToken;
Map<String, String> requestHeaders = Map();

