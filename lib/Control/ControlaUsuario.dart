import 'package:ifuel/helpers/contact_help.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Entity/Usuario.dart';

class ControlaUsuario{
  Usuario usuario;
  ContactHelper contactHelper = ContactHelper();




  ControlaUsuario({this.usuario});

  void cadastrar(Usuario usuario){
    contactHelper.saveUsuario(usuario);
  }
  void editar(){}


  Future<bool> login(String login, int senha) async {
    // ignore: missing_return
    final prefs = await SharedPreferences.getInstance();
    await contactHelper.getUsuario(login).then((result){
      if(result.senha==senha){
        prefs.setString("Usuario", login);
        prefs.setString("Status", 'logado');
        print('logado');
        return true;
      }else{
        return false;
      }

    });
    return false;
  }
  void logout(){}


}