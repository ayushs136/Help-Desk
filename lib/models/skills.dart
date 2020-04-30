class Skills {
   String skill1;
   String skill2;
   String skill3;
   String skill4;

  Skills({this.skill1, this.skill2, this.skill3, this.skill4});

    Map<String, String> skillJson() => {
        'skill1': skill1,
        'skill2': skill2,
        'skill3': skill3,
        'skill4': skill4,
      };
}
