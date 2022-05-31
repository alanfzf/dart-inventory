class Groups{

  Groups._();

  static bool hasPermission(int groupId, Permission perm){

    
      switch(groupId){
          case 1:
              return true;
          case 2:
              return perm == Permission.empleado;
          case 3:
              return perm == Permission.finanzas;
          default:
              return false;
      }
  }

  static String getGroupName(int groupId){
      switch(groupId){
            case 1:
                return "Administrador";
            case 2:
                return "Empleado";
            case 3:
                return "Finanzas";
            default:
                return "Invitado";
        }
      }
}

enum Permission{
    administrador,
    empleado,
    finanzas,
}