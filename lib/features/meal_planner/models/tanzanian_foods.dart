/// Tanzanian Local Foods Database
/// Contains nutritional information and availability locations for traditional Tanzanian foods
library;

class TanzanianFoodLocation {
  final String region;
  final String availability;
  final String seasonality;

  const TanzanianFoodLocation({
    required this.region,
    required this.availability,
    required this.seasonality,
  });
}

class TanzanianFood {
  final String id;
  final String name;
  final String swahiliName;
  final String description;
  final Map<String, double>
  nutrients; // calories, protein, carbs, fat, fiber, etc.
  final List<String> mealTypes;
  final List<String> categories;
  final TanzanianFoodLocation location;
  final List<String> healthBenefits;
  final String preparationTips;
  final String imageUrl;
  final List<String> ingredients;

  const TanzanianFood({
    required this.id,
    required this.name,
    required this.swahiliName,
    required this.description,
    required this.nutrients,
    required this.mealTypes,
    required this.categories,
    required this.location,
    required this.healthBenefits,
    required this.preparationTips,
    this.imageUrl = '',
    this.ingredients = const [],
  });

  // Get formatted nutritional info
  String getNutritionalInfo() {
    return '''
Calories: ${nutrients['calories']?.toStringAsFixed(0) ?? 'N/A'} kcal
Protein: ${nutrients['protein']?.toStringAsFixed(1) ?? 'N/A'}g
Carbs: ${nutrients['carbs']?.toStringAsFixed(1) ?? 'N/A'}g
Fat: ${nutrients['fat']?.toStringAsFixed(1) ?? 'N/A'}g
Fiber: ${nutrients['fiber']?.toStringAsFixed(1) ?? 'N/A'}g
Iron: ${nutrients['iron']?.toStringAsFixed(1) ?? 'N/A'}mg
Vitamin A: ${nutrients['vitaminA']?.toStringAsFixed(0) ?? 'N/A'} IU
''';
  }
}

class TanzanianFoodsDatabase {
  static const List<TanzanianFood> allFoods = [
    // UGALI - National Staple
    TanzanianFood(
      id: 'ugali',
      name: 'Ugali',
      swahiliName: 'Ugali',
      description:
          'Thick maize porridge, Tanzania\'s national staple food made from maize flour.',
      nutrients: {
        'calories': 360.0,
        'protein': 8.3,
        'carbs': 77.0,
        'fat': 1.5,
        'fiber': 7.3,
        'iron': 2.7,
        'vitaminA': 0,
      },
      mealTypes: ['breakfast', 'lunch', 'dinner'],
      categories: ['staple', 'carbs', 'traditional'],
      location: TanzanianFoodLocation(
        region: 'Nationwide',
        availability:
            'Available everywhere - markets, supermarkets, local shops',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'Provides sustained energy',
        'Good source of complex carbohydrates',
        'Supports digestive health with fiber',
        'Cost-effective and filling',
      ],
      preparationTips:
          'Boil water, gradually add maize flour while stirring continuously until thick and smooth.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/4/48/Ugali_%26_Sukuma_Wiki.jpg',
      ingredients: ['maize flour', 'water'],
    ),

    // SUKUMA WIKI - Kale
    TanzanianFood(
      id: 'sukuma_wiki',
      name: 'Sukuma Wiki',
      swahiliName: 'Sukuma Wiki',
      description:
          'Collard greens or kale, a popular leafy vegetable in Tanzanian cuisine.',
      nutrients: {
        'calories': 32.0,
        'protein': 3.0,
        'carbs': 5.8,
        'fat': 0.6,
        'fiber': 4.1,
        'iron': 1.1,
        'vitaminA': 12061,
      },
      mealTypes: ['lunch', 'dinner', 'side'],
      categories: ['vegetable', 'leafy_greens', 'traditional'],
      location: TanzanianFoodLocation(
        region: 'Nationwide, especially coastal and central regions',
        availability: 'Fresh markets, supermarkets, local vendors',
        seasonality: 'Year-round, best in rainy season',
      ),
      healthBenefits: [
        'Excellent source of Vitamin A for eye health',
        'High in iron for blood health',
        'Rich in antioxidants',
        'Supports bone health with calcium',
      ],
      preparationTips:
          'Wash thoroughly, remove tough stems, cook with onions, tomatoes, and spices.',
      imageUrl:
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500&q=80',
      ingredients: [
        'collard greens',
        'onions',
        'tomatoes',
        'oil',
        'salt',
        'spices',
      ],
    ),

    // SAMAKI - Fish
    TanzanianFood(
      id: 'samaki',
      name: 'Fresh Fish (Tilapia/Nile Perch)',
      swahiliName: 'Samaki',
      description:
          'Fresh fish from Lake Victoria and coastal waters, a protein-rich staple.',
      nutrients: {
        'calories': 128.0,
        'protein': 26.0,
        'carbs': 0.0,
        'fat': 2.7,
        'fiber': 0.0,
        'iron': 0.6,
        'vitaminA': 12,
      },
      mealTypes: ['lunch', 'dinner'],
      categories: ['protein', 'seafood', 'traditional'],
      location: TanzanianFoodLocation(
        region:
            'Lake Victoria (Mwanza, Musoma), Coastal areas (Dar es Salaam, Tanga, Zanzibar)',
        availability: 'Fresh fish markets, supermarkets, local fishermen',
        seasonality: 'Year-round, best during rainy season',
      ),
      healthBenefits: [
        'High-quality complete protein',
        'Rich in omega-3 fatty acids',
        'Low in saturated fat',
        'Supports heart and brain health',
      ],
      ingredients: ['tilapia', 'salt', 'spices', 'oil'],
      preparationTips:
          'Clean thoroughly, can be grilled, fried, or cooked in stew. Popular with ugali.',
      imageUrl:
          'https://images.unsplash.com/photo-1559847844-5315695dadae?w=500&q=80',
    ),

    // NYAMA CHOMA - Grilled Meat
    TanzanianFood(
      id: 'nyama_choma',
      name: 'Nyama Choma (Grilled Meat)',
      swahiliName: 'Nyama Choma',
      description:
          'Grilled goat or beef meat, Tanzania\'s favorite barbecue dish.',
      nutrients: {
        'calories': 250.0,
        'protein': 30.0,
        'carbs': 0.0,
        'fat': 14.0,
        'fiber': 0.0,
        'iron': 2.6,
        'vitaminA': 0,
      },
      mealTypes: ['lunch', 'dinner', 'special_occasions'],
      categories: ['protein', 'meat', 'traditional', 'barbecue'],
      location: TanzanianFoodLocation(
        region: 'Nationwide, especially popular in Arusha and tourist areas',
        availability: 'Local restaurants, food stalls, butcher shops',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'Excellent source of complete protein',
        'Rich in B vitamins for energy metabolism',
        'Provides iron for oxygen transport',
        'Contains zinc for immune function',
      ],
      ingredients: ['goat meat', 'salt', 'spices', 'oil'],
      preparationTips:
          'Marinate in salt and spices, grill over medium heat. Serve with kachumbari salad.',
      imageUrl:
          'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=500&q=80',
    ),

    // WALI - Rice
    TanzanianFood(
      id: 'wali',
      name: 'Wali (Rice)',
      swahiliName: 'Wali',
      description: 'Steamed rice, commonly served with stews and meat dishes.',
      nutrients: {
        'calories': 130.0,
        'protein': 2.7,
        'carbs': 28.0,
        'fat': 0.3,
        'fiber': 0.4,
        'iron': 0.2,
        'vitaminA': 0,
      },
      mealTypes: ['lunch', 'dinner'],
      categories: ['staple', 'carbs', 'traditional'],
      location: TanzanianFoodLocation(
        region: 'Nationwide',
        availability:
            'Supermarkets, local markets, rice farms in Morogoro and Mbeya',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'Provides quick energy from carbohydrates',
        'Low in fat',
        'Contains some B vitamins',
        'Versatile base for nutrient absorption',
      ],
      preparationTips:
          'Rinse rice, boil with water (1:2 ratio), simmer covered until fluffy.',
      imageUrl:
          'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?w=500&q=80',
    ),

    // MAANDASI - Rice Pancakes
    TanzanianFood(
      id: 'maandasi',
      name: 'Maandasi (Rice Pancakes)',
      swahiliName: 'Maandasi',
      description:
          'Sweet fried rice flour pancakes, popular breakfast or snack item.',
      nutrients: {
        'calories': 180.0,
        'protein': 3.5,
        'carbs': 32.0,
        'fat': 5.0,
        'fiber': 1.2,
        'iron': 0.8,
        'vitaminA': 0,
      },
      mealTypes: ['breakfast', 'snack'],
      categories: ['sweet', 'snack', 'traditional'],
      location: TanzanianFoodLocation(
        region: 'Coastal areas (Zanzibar, Dar es Salaam), Swahili communities',
        availability: 'Street vendors, local bakeries, markets',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'Provides quick energy for busy mornings',
        'Contains some protein and minerals',
        'Cultural comfort food',
        'Made with local rice flour',
      ],
      preparationTips:
          'Mix rice flour with sugar, yeast, and water. Deep fry in vegetable oil until golden.',
      imageUrl:
          'https://images.unsplash.com/photo-1554520735-0a6bfee2b6b8?w=500&q=80',
    ),

    // MTORI - Coconut Rice
    TanzanianFood(
      id: 'mtori',
      name: 'Mtori (Coconut Rice)',
      swahiliName: 'Mtori',
      description:
          'Rice cooked with coconut milk, a coastal delicacy from Zanzibar.',
      nutrients: {
        'calories': 200.0,
        'protein': 3.2,
        'carbs': 35.0,
        'fat': 5.5,
        'fiber': 0.8,
        'iron': 0.5,
        'vitaminA': 0,
      },
      mealTypes: ['lunch', 'dinner', 'special_occasions'],
      categories: ['rice_dish', 'coconut', 'coastal'],
      location: TanzanianFoodLocation(
        region: 'Zanzibar, coastal areas (Tanga, Dar es Salaam)',
        availability: 'Local restaurants, coconut farms, markets',
        seasonality: 'Year-round, coconut season October-March',
      ),
      healthBenefits: [
        'Coconut provides healthy fats',
        'Contains lauric acid with antimicrobial properties',
        'Rich in manganese and copper',
        'Provides sustained energy',
      ],
      preparationTips:
          'Cook rice with coconut milk instead of water. Add spices like cardamom and cloves.',
      imageUrl:
          'https://images.unsplash.com/photo-1563379091339-03246963d96c?w=500&q=80',
    ),

    // NDIZI - Plantains/Bananas
    TanzanianFood(
      id: 'ndizi',
      name: 'Ndizi (Plantains)',
      swahiliName: 'Ndizi',
      description: 'Cooking bananas/plantains, boiled, fried, or roasted.',
      nutrients: {
        'calories': 122.0,
        'protein': 1.3,
        'carbs': 31.9,
        'fat': 0.4,
        'fiber': 2.3,
        'iron': 0.6,
        'vitaminA': 457,
      },
      mealTypes: ['breakfast', 'snack', 'side'],
      categories: ['fruit', 'carbs', 'traditional'],
      location: TanzanianFoodLocation(
        region: 'Nationwide, especially coastal and southern regions',
        availability: 'Local markets, banana plantations in Kagera and Mwanza',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'Good source of resistant starch',
        'Contains potassium for blood pressure',
        'Provides vitamin A for eye health',
        'Rich in vitamin C',
      ],
      preparationTips:
          'Can be boiled, fried, or roasted. Popular as matoke (cooked plantains).',
      imageUrl:
          'https://images.unsplash.com/photo-1571771019784-3ff35f4f4277?w=500&q=80',
    ),

    // VIAZI KARAI - Fried Potatoes
    TanzanianFood(
      id: 'viazi_karai',
      name: 'Viazi Karai (Fried Potatoes)',
      swahiliName: 'Viazi Karai',
      description:
          'Crispy fried potatoes, a popular street food and side dish.',
      nutrients: {
        'calories': 312.0,
        'protein': 3.6,
        'carbs': 41.0,
        'fat': 15.0,
        'fiber': 3.8,
        'iron': 1.8,
        'vitaminA': 0,
      },
      mealTypes: ['snack', 'side', 'street_food'],
      categories: ['potatoes', 'fried', 'street_food'],
      location: TanzanianFoodLocation(
        region: 'Urban areas (Dar es Salaam, Arusha, Mwanza)',
        availability: 'Street vendors, fast food restaurants, markets',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'Provides vitamin C from potatoes',
        'Contains potassium for electrolyte balance',
        'Fiber supports digestive health',
        'Energy-dense for active lifestyles',
      ],
      preparationTips:
          'Peel and slice potatoes, soak in water, deep fry until golden and crispy.',
      imageUrl:
          'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=500&q=80',
    ),

    // PILAU - Spiced Rice
    TanzanianFood(
      id: 'pilau',
      name: 'Pilau (Spiced Rice)',
      swahiliName: 'Pilau',
      description:
          'Fragrant spiced rice dish with meat, onions, and aromatic spices.',
      nutrients: {
        'calories': 180.0,
        'protein': 4.5,
        'carbs': 32.0,
        'fat': 4.0,
        'fiber': 1.2,
        'iron': 1.2,
        'vitaminA': 0,
      },
      mealTypes: ['lunch', 'dinner', 'special_occasions'],
      categories: ['rice_dish', 'spiced', 'festive'],
      location: TanzanianFoodLocation(
        region: 'Coastal areas, Swahili communities, urban centers',
        availability: 'Restaurants, during celebrations, local caterers',
        seasonality: 'Year-round, especially during Ramadan and Eid',
      ),
      healthBenefits: [
        'Spices provide antioxidants',
        'Contains anti-inflammatory compounds',
        'Provides complex carbohydrates',
        'Cultural and social significance',
      ],
      preparationTips:
          'Fry onions and spices, add meat, then rice and water. Cook covered until rice is tender.',
      imageUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&q=80',
    ),

    // KACHUMBARI - Tomato Salad
    TanzanianFood(
      id: 'kachumbari',
      name: 'Kachumbari (Tomato Salad)',
      swahiliName: 'Kachumbari',
      description: 'Fresh tomato and onion salad, served with grilled meats.',
      nutrients: {
        'calories': 24.0,
        'protein': 1.2,
        'carbs': 5.0,
        'fat': 0.2,
        'fiber': 1.3,
        'iron': 0.3,
        'vitaminA': 833,
      },
      mealTypes: ['side', 'accompaniment'],
      categories: ['salad', 'fresh', 'traditional'],
      location: TanzanianFoodLocation(
        region: 'Nationwide',
        availability: 'Local markets, served with nyama choma',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'Rich in vitamin C for immunity',
        'Contains lycopene antioxidant',
        'Low in calories',
        'Hydrating and refreshing',
      ],
      preparationTips:
          'Dice tomatoes and onions, add cilantro, lime juice, and salt. Let marinate briefly.',
      imageUrl:
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500&q=80',
    ),

    // UJI - Millet Porridge
    TanzanianFood(
      id: 'uji',
      name: 'Uji (Millet Porridge)',
      swahiliName: 'Uji',
      description: 'Nutritious millet porridge, traditional breakfast drink.',
      nutrients: {
        'calories': 120.0,
        'protein': 4.0,
        'carbs': 25.0,
        'fat': 1.0,
        'fiber': 2.5,
        'iron': 1.5,
        'vitaminA': 0,
      },
      mealTypes: ['breakfast', 'snack'],
      categories: ['porridge', 'traditional', 'drink'],
      location: TanzanianFoodLocation(
        region: 'Nationwide, especially rural areas',
        availability: 'Local markets, millet farms in Shinyanga and Mara',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'High in protein and fiber',
        'Contains essential minerals',
        'Gluten-free grain',
        'Supports digestive health',
      ],
      preparationTips:
          'Roast millet, grind into flour, cook with water while stirring until smooth.',
      imageUrl:
          'https://mkulimambunifu.org/wp-content/uploads/2021/11/uji-wa-ulezi.jpg',
    ),

    // MCHICHA - Groundnuts
    TanzanianFood(
      id: 'mchicha',
      name: 'Mchicha (Groundnuts/Peanuts)',
      swahiliName: 'Mchicha',
      description: 'Roasted peanuts, a popular snack and protein source.',
      nutrients: {
        'calories': 567.0,
        'protein': 25.8,
        'carbs': 16.3,
        'fat': 49.2,
        'fiber': 8.5,
        'iron': 4.6,
        'vitaminA': 0,
      },
      mealTypes: ['snack', 'side'],
      categories: ['nuts', 'protein', 'snack'],
      location: TanzanianFoodLocation(
        region: 'Nationwide, major production in Dodoma and Singida',
        availability: 'Markets, street vendors, supermarkets',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'Excellent plant-based protein source',
        'Rich in healthy fats',
        'Contains resveratrol antioxidant',
        'Supports heart health',
      ],
      preparationTips:
          'Roast in shell or without, can be eaten plain or used in cooking.',
      imageUrl:
          'https://images.unsplash.com/photo-1567721913486-6585f069b332?w=500&q=80',
    ),

    // TAMU - Mangoes
    TanzanianFood(
      id: 'tamu',
      name: 'Tamu (Mangoes)',
      swahiliName: 'Tamu',
      description: 'Sweet tropical mangoes, Tanzania\'s national fruit.',
      nutrients: {
        'calories': 60.0,
        'protein': 0.8,
        'carbs': 15.0,
        'fat': 0.4,
        'fiber': 1.6,
        'iron': 0.2,
        'vitaminA': 1584,
      },
      mealTypes: ['snack', 'dessert'],
      categories: ['fruit', 'tropical', 'national'],
      location: TanzanianFoodLocation(
        region: 'Coastal areas, Morogoro, Tanga - major production areas',
        availability: 'Local markets, fruit stands, export quality',
        seasonality: 'December to March (peak season)',
      ),
      healthBenefits: [
        'Rich in vitamin A for eye health',
        'Contains vitamin C for immunity',
        'Provides antioxidants',
        'Supports skin health',
      ],
      preparationTips:
          'Eat fresh when ripe, can be used in juices, salads, or dried.',
      imageUrl:
          'https://images.unsplash.com/photo-1553279768-865429fa0078?w=500&q=80',
    ),

    // NANASI - Pineapples
    TanzanianFood(
      id: 'nanasi',
      name: 'Nanasi (Pineapples)',
      swahiliName: 'Nanasi',
      description: 'Sweet and juicy pineapples, grown in coastal regions.',
      nutrients: {
        'calories': 50.0,
        'protein': 0.5,
        'carbs': 13.0,
        'fat': 0.1,
        'fiber': 1.4,
        'iron': 0.3,
        'vitaminA': 58,
      },
      mealTypes: ['snack', 'dessert', 'juice'],
      categories: ['fruit', 'tropical', 'export'],
      location: TanzanianFoodLocation(
        region: 'Coastal regions (Tanga, Morogoro), Zanzibar',
        availability: 'Local markets, fruit farms, supermarkets',
        seasonality: 'Year-round, peak November-February',
      ),
      healthBenefits: [
        'Contains bromelain enzyme for digestion',
        'Rich in vitamin C',
        'Supports immune function',
        'Anti-inflammatory properties',
      ],
      preparationTips:
          'Peel and eat fresh, excellent for juices and fruit salads.',
      imageUrl:
          'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=500&q=80',
    ),

    // MIHOGO - Cassava
    TanzanianFood(
      id: 'mihogo',
      name: 'Mihogo (Cassava)',
      swahiliName: 'Mihogo',
      description:
          'Cassava root, boiled or roasted, important staple in many regions.',
      nutrients: {
        'calories': 160.0,
        'protein': 1.4,
        'carbs': 38.0,
        'fat': 0.3,
        'fiber': 1.8,
        'iron': 0.3,
        'vitaminA': 13,
      },
      mealTypes: ['lunch', 'dinner', 'snack'],
      categories: ['root_vegetable', 'staple', 'traditional'],
      location: TanzanianFoodLocation(
        region: 'Coastal areas, southern regions (Mbeya, Ruvuma)',
        availability: 'Local markets, cassava farms',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'Provides resistant starch',
        'Contains some vitamin C',
        'Good energy source',
        'Must be properly cooked to remove toxins',
      ],
      preparationTips:
          'Peel thoroughly, boil or roast until soft. Never eat raw cassava.',
      imageUrl:
          'https://images.unsplash.com/photo-1592173272822-2b3b7c6d1b1c?w=500&q=80',
    ),

    // VITIMBI - Bambara Nuts
    TanzanianFood(
      id: 'vitimbi',
      name: 'Vitimbi (Bambara Nuts)',
      swahiliName: 'Vitimbi',
      description: 'Protein-rich nuts, boiled or roasted, traditional food.',
      nutrients: {
        'calories': 364.0,
        'protein': 19.0,
        'carbs': 63.0,
        'fat': 6.5,
        'fiber': 6.2,
        'iron': 4.2,
        'vitaminA': 0,
      },
      mealTypes: ['snack', 'side'],
      categories: ['nuts', 'protein', 'traditional'],
      location: TanzanianFoodLocation(
        region: 'Central and southern regions (Dodoma, Iringa)',
        availability: 'Local markets, traditional food stores',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'High-quality plant protein',
        'Rich in complex carbohydrates',
        'Contains essential minerals',
        'Sustainable crop for dry areas',
      ],
      preparationTips:
          'Soak overnight, boil until soft, or roast. Can be eaten as snack or added to stews.',
      imageUrl:
          'https://images.unsplash.com/photo-1596599630513-1709e1b2b8c8?w=500&q=80',
    ),

    // CHIPS MAYAI - Egg Omelette with Chips
    TanzanianFood(
      id: 'chips_mayai',
      name: 'Chips Mayai (Egg Omelette with Chips)',
      swahiliName: 'Chips Mayai',
      description:
          'Popular street food combining french fries with egg omelette.',
      nutrients: {
        'calories': 420.0,
        'protein': 18.0,
        'carbs': 45.0,
        'fat': 20.0,
        'fiber': 3.5,
        'iron': 2.1,
        'vitaminA': 540,
      },
      mealTypes: ['breakfast', 'lunch', 'street_food'],
      categories: ['street_food', 'protein', 'fusion'],
      location: TanzanianFoodLocation(
        region: 'Urban areas (Dar es Salaam, Arusha, Mwanza)',
        availability: 'Street vendors, fast food restaurants',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'Complete protein from eggs',
        'Provides vitamin A from egg yolks',
        'Energy-dense meal',
        'Popular among working population',
      ],
      preparationTips:
          'Fry potatoes into chips, beat eggs with spices, cook together until eggs are set.',
      imageUrl:
          'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=500&q=80',
    ),

    // BIRYANI - Rice Dish
    TanzanianFood(
      id: 'biryani',
      name: 'Biryani (Spiced Rice with Meat)',
      swahiliName: 'Biryani',
      description:
          'Aromatic spiced rice dish with meat, influenced by Indian cuisine.',
      nutrients: {
        'calories': 280.0,
        'protein': 15.0,
        'carbs': 35.0,
        'fat': 10.0,
        'fiber': 2.1,
        'iron': 2.5,
        'vitaminA': 0,
      },
      mealTypes: ['lunch', 'dinner', 'special_occasions'],
      categories: ['rice_dish', 'spiced', 'fusion'],
      location: TanzanianFoodLocation(
        region: 'Urban areas, especially Dar es Salaam and Zanzibar',
        availability: 'Indian restaurants, local eateries, during celebrations',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'Balanced meal with protein and carbs',
        'Spices provide antioxidants',
        'Contains anti-inflammatory compounds',
        'Cultural fusion dish',
      ],
      preparationTips:
          'Layer spiced rice with marinated meat, cook covered with saffron and spices.',
      imageUrl:
          'https://images.unsplash.com/photo-1563379091339-03246963d96c?w=500&q=80',
    ),

    // SAMOSA - Fried Pastries
    TanzanianFood(
      id: 'samosa',
      name: 'Samosa (Meat-Filled Pastries)',
      swahiliName: 'Samosa',
      description:
          'Crispy fried pastries filled with spiced meat and vegetables.',
      nutrients: {
        'calories': 250.0,
        'protein': 8.0,
        'carbs': 28.0,
        'fat': 12.0,
        'fiber': 2.5,
        'iron': 1.8,
        'vitaminA': 0,
      },
      mealTypes: ['snack', 'appetizer'],
      categories: ['snack', 'fried', 'fusion'],
      location: TanzanianFoodLocation(
        region: 'Urban areas, especially coastal cities',
        availability: 'Street vendors, bakeries, supermarkets',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'Provides protein from meat filling',
        'Contains vegetables for nutrients',
        'Energy-dense snack',
        'Popular quick meal option',
      ],
      preparationTips:
          'Make dough, fill with spiced meat and vegetables, deep fry until golden.',
      imageUrl:
          'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=500&q=80',
    ),

    // CHAI - Tea
    TanzanianFood(
      id: 'chai',
      name: 'Chai (Spiced Tea)',
      swahiliName: 'Chai',
      description:
          'Spiced black tea with milk and spices, Tanzania\'s favorite hot drink.',
      nutrients: {
        'calories': 80.0,
        'protein': 3.5,
        'carbs': 10.0,
        'fat': 3.0,
        'fiber': 0.0,
        'iron': 0.1,
        'vitaminA': 0,
      },
      mealTypes: ['breakfast', 'snack', 'beverage'],
      categories: ['beverage', 'hot_drink', 'traditional'],
      location: TanzanianFoodLocation(
        region: 'Nationwide, especially in tea-growing areas (Arusha, Mbeya)',
        availability: 'Local shops, hotels, homes',
        seasonality: 'Year-round',
      ),
      healthBenefits: [
        'Contains antioxidants from tea',
        'Spices have anti-inflammatory properties',
        'Provides some calcium from milk',
        'Traditional comfort drink',
      ],
      preparationTips:
          'Boil water with tea leaves, add spices (ginger, cardamom, cloves), add milk and sugar.',
      imageUrl:
          'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=500&q=80',
    ),
  ];

  // Get foods by region
  static List<TanzanianFood> getFoodsByRegion(String region) {
    return allFoods
        .where(
          (food) =>
              food.location.region.toLowerCase().contains(
                region.toLowerCase(),
              ) ||
              food.location.region == 'Nationwide',
        )
        .toList();
  }

  // Get foods by category
  static List<TanzanianFood> getFoodsByCategory(String category) {
    return allFoods
        .where((food) => food.categories.contains(category.toLowerCase()))
        .toList();
  }

  // Get foods by meal type
  static List<TanzanianFood> getFoodsByMealType(String mealType) {
    return allFoods
        .where((food) => food.mealTypes.contains(mealType.toLowerCase()))
        .toList();
  }

  // Get foods by nutritional criteria
  static List<TanzanianFood> getHighProteinFoods({double minProtein = 15.0}) {
    return allFoods
        .where((food) => (food.nutrients['protein'] ?? 0) >= minProtein)
        .toList();
  }

  static List<TanzanianFood> getLowCalorieFoods({double maxCalories = 200.0}) {
    return allFoods
        .where((food) => (food.nutrients['calories'] ?? 0) <= maxCalories)
        .toList();
  }

  // Get traditional staple foods
  static List<TanzanianFood> getStapleFoods() {
    return getFoodsByCategory('staple');
  }

  // Get regional specialties
  static List<TanzanianFood> getCoastalFoods() {
    return getFoodsByRegion('coastal');
  }

  static List<TanzanianFood> getLakeVictoriaFoods() {
    return getFoodsByRegion('victoria');
  }

  static List<TanzanianFood> getZanzibarFoods() {
    return getFoodsByRegion('zanzibar');
  }
}
