import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  
  final Contact? contact;

  ContactPage({this.contact});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();
  
  bool _userEdited = false;
  Contact? _editContact;

  @override
  void initState() {
    
    super.initState();

    if(widget.contact == null){
      _editContact = Contact();
    }else{
      _editContact = Contact.fromMap(widget.contact!.toMap());

      _nameController.text = _editContact!.name.toString();
      _emailController.text = _editContact!.email.toString();
      _phoneController.text = _editContact!.phone.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editContact!.name ?? "Novo contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editContact!.name != null && _editContact!.name!.isNotEmpty){
              Navigator.pop(context, _editContact);
            }else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: const Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
    
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  ImagePicker.platform.pickImage(
                    source: ImageSource.camera
                  ).then((value) => {
                    if(value.path != null){
                      setState(() {
                        _editContact!.img = value.path;
                      })
                    },
                    
                  });
                },
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white54,
                      width: 5
                    ),
                    borderRadius: BorderRadius.circular(150),
                    // shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editContact!.img != null ?
                      FileImage(File(_editContact!.img as String)) : 
                      const AssetImage("images/avatar-5.png") as ImageProvider
                    )
                  ),
                ),
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: const InputDecoration(
                  labelText: 'Nome'
                ),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editContact!.name = text;
                  });
                },
              ),
    
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email'
                ),
                onChanged: (text){
                  _userEdited = true;
                  _editContact!.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
    
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone'
                ),
                onChanged: (text){
                  _userEdited = true;
                  _editContact!.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Descartar Alterações ?'),
            content: Text('Se sair as alterações serão perdidas.'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);

                },
                child: const Text('Sim'),
              ),
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}