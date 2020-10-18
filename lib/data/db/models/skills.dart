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

  Map toMap(Skills skills) {
    var data = Map<String, String>();
    data['skill1'] = skills.skill1;
    data['skill2'] = skills.skill2;
    data['skill3'] = skills.skill3;
    data['skill4'] = skills.skill4;

    return data;
  }

}
