enum NutritionCohort {
  mothersChildren('mothers_children', 'Akina Mama na Watoto',
      'Kwa wanawake wajawazito, wanaonyonyesha, na watoto chini ya miaka 5'),
  adolescents('adolescents', 'Vijana',
      'Kwa vijana na vijana wachanga wenye umri wa miaka 10-19'),
  ncd('ncd', 'Magonjwa Yasiyoambukiza',
      'Kwa wanaoishi na kisukari, shinikizo la damu, n.k.'),
  malnutrition('malnutrition', 'Utapiamlo',
      'Kwa wenye upungufu wa uzito au virutubisho'),
  schoolStudents('school_students', 'Wanafunzi wa Shule',
      'Kwa wanafunzi wa shule za msingi na sekondari'),
  universityStudents('university_students', 'Wanafunzi wa Vyuo Vikuu',
      'Kwa wanafunzi wa vyuo vikuu na vijana wazima');

  final String id;
  final String displayName;
  final String description;

  const NutritionCohort(this.id, this.displayName, this.description);

  static NutritionCohort fromId(String id) {
    return NutritionCohort.values.firstWhere(
      (cohort) => cohort.id == id,
      orElse: () => NutritionCohort.universityStudents,
    );
  }

  static List<Map<String, dynamic>> getCohortList(String locale) {
    return NutritionCohort.values.map((cohort) {
      return {
        'id': cohort.id,
        'name': cohort.displayName,
        'description': cohort.description,
      };
    }).toList();
  }
}
