import '../models/drink.dart';

class MockDataService {
  static List<Drink> getDrinks() {
    return [
      Drink(
        id: '1',
        name: 'Classic Cola',
        price: 2.50,
        image: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=400',
        category: 'Cold Drinks',
        description: 'Ice-cold classic cola, refreshing and bubbly.',
        isPopular: true,
      ),
      Drink(
        id: '2',
        name: 'Iced Coffee',
        price: 4.00,
        image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400',
        category: 'Coffee',
        description: 'Smooth iced coffee with a hint of vanilla.',
        isPopular: true,
      ),
      Drink(
        id: '3',
        name: 'Mango Smoothie',
        price: 3.50,
        image: 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=400',
        category: 'Smoothies',
        description: 'Fresh mango blended with creamy yoghurt.',
        isPopular: true,
      ),
      Drink(
        id: '4',
        name: 'Green Tea Latte',
        price: 3.75,
        image: 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=400',
        category: 'Tea',
        description: 'Premium matcha green tea with steamed oat milk.',
        isPopular: false,
      ),
      Drink(
        id: '5',
        name: 'Strawberry Lemonade',
        price: 3.00,
        image: 'https://images.unsplash.com/photo-1497534446932-c925b458314e?w=400',
        category: 'Cold Drinks',
        description: 'Freshly squeezed lemon with sweet strawberry puree.',
        isPopular: true,
      ),
      Drink(
        id: '6',
        name: 'Cappuccino',
        price: 4.50,
        image: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400',
        category: 'Coffee',
        description: 'Rich espresso topped with velvety frothed milk.',
        isPopular: false,
      ),
      Drink(
        id: '7',
        name: 'Watermelon Juice',
        price: 2.75,
        image: 'https://images.unsplash.com/photo-1623010738213-5a4b43d61527?w=400',
        category: 'Juices',
        description: 'Pure pressed watermelon, no added sugar.',
        isPopular: false,
      ),
      Drink(
        id: '8',
        name: 'Chocolate Milkshake',
        price: 4.25,
        image: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400',
        category: 'Smoothies',
        description: 'Thick creamy chocolate shake made with real cacao.',
        isPopular: true,
      ),
      Drink(
        id: '9',
        name: 'Chamomile Tea',
        price: 2.50,
        image: 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400',
        category: 'Tea',
        description: 'Soothing chamomile herbal tea, perfect to relax.',
        isPopular: false,
      ),
      Drink(
        id: '10',
        name: 'Orange Juice',
        price: 3.00,
        image: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400',
        category: 'Juices',
        description: 'Freshly squeezed orange juice, rich in Vitamin C.',
        isPopular: false,
      ),
      Drink(
        id: '11',
        name: 'Espresso Shot',
        price: 2.00,
        image: 'https://images.unsplash.com/photo-1510707577719-ae7c14805e3a?w=400',
        category: 'Coffee',
        description: 'Single shot of bold premium espresso.',
        isPopular: false,
      ),
      Drink(
        id: '12',
        name: 'Blueberry Smoothie',
        price: 3.75,
        image: 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=400',
        category: 'Smoothies',
        description: 'Antioxidant-rich blueberry smoothie with almond milk.',
        isPopular: true,
      ),
    ];
  }

  static List<String> getCategories() {
    return ['All', 'Coffee', 'Cold Drinks', 'Tea', 'Smoothies', 'Juices'];
  }
}