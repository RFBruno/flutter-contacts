import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
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
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editContact!.img != null ?
                      // FileImage(File(_editContact!.img))
                      AssetImage('images/avatar-5.png') :
                      AssetImage('images/avatar-5.png') 
                      
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
    );
  }
}