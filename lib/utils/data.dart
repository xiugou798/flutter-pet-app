var profile = "https://avatars.githubusercontent.com/u/86506519?v=4";

List categories = [
  {"name": "All", "zh": "全部", "icon": "assets/icons/pet-border.svg"},
  {"name": "Dog", "zh": "狗","icon": "assets/icons/dog.svg"},
  {"name": "Cat", "zh": "猫","icon": "assets/icons/cat.svg"},
  {"name": "Parrot", "zh": "鹦鹉","icon": "assets/icons/parrot.svg"},
  {"name": "Rabbit", "zh": "兔子","icon": "assets/icons/rabbit.svg"},
  {"name": "Fish", "zh": "鱼","icon": "assets/icons/fish.svg"},
  {"name": "Turtle", "zh": "乌龟","icon": "assets/icons/turtle.svg"},
];

// List pets = [
//   {
//     "image":
//         "https://images.unsplash.com/photo-1583511655826-05700d52f4d9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     "name": "Cheero",
//     "location": "Siem Reap, Cambodia",
//     "is_favorited": true,
//     "description":
//         "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
//     "rate": 4.5,
//     "id": "pid001",
//     "price": "\$1,250",
//     "owner_name": "Sangvaleap",
//     "owner_photo": profile,
//     "sex": "Male",
//     "age": "5 Months",
//     "color": "Brown",
//     "type": "Dog",
//     "album": [
//       "https://images.unsplash.com/photo-1558788353-f76d92427f16??ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1537151625747-768eb6cf92b2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583511655826-05700d52f4d9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1591768575198-88dac53fbd0a?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     ]
//   },
//   {
//     "image":
//         "https://images.unsplash.com/photo-1591768575198-88dac53fbd0a?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     "name": "Bossy",
//     "location": "Phnom Penh, Cambodia",
//     "is_favorited": false,
//     "description":
//         "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
//     "rate": 4.5,
//     "id": "pid001",
//     "price": "\$1,250",
//     "owner_name": "Sangvaleap",
//     "owner_photo": profile,
//     "sex": "Male",
//     "age": "5 Months",
//     "color": "Brown",
//     "type": "Dog",
//     "album": [
//       "https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1537151625747-768eb6cf92b2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583511655826-05700d52f4d9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1591768575198-88dac53fbd0a?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     ]
//   },
//   {
//     "image":
//         "https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     "name": "Maxi",
//     "location": "Battambang, Cambodia",
//     "is_favorited": false,
//     "description":
//         "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
//     "rate": 4.5,
//     "id": "pid001",
//     "price": "\$1,250",
//     "owner_name": "Sangvaleap",
//     "owner_photo": profile,
//     "sex": "Male",
//     "age": "5 Months",
//     "color": "Brown",
//     "type": "Dog",
//     "album": [
//       "https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1537151625747-768eb6cf92b2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583511655826-05700d52f4d9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1591768575198-88dac53fbd0a?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     ]
//   },
//   {
//     "image":
//         "https://images.unsplash.com/photo-1588269845464-8993565cac3a?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     "name": "Coca",
//     "location": "Phnom Penh, Cambodia",
//     "is_favorited": false,
//     "description":
//         "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
//     "rate": 4.5,
//     "id": "pid001",
//     "price": "\$1,250",
//     "owner_name": "Sangvaleap",
//     "owner_photo": profile,
//     "sex": "Male",
//     "age": "5 Months",
//     "color": "Brown",
//     "type": "Dog",
//     "album": [
//       "https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1537151625747-768eb6cf92b2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583511655826-05700d52f4d9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1591768575198-88dac53fbd0a?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     ]
//   },
//   {
//     "image":
//         "https://images.unsplash.com/photo-1556227702-d1e4e7b5c232?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     "name": "Lazoo",
//     "location": "Phnom Penh, Cambodia",
//     "is_favorited": true,
//     "description":
//         "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
//     "rate": 4.5,
//     "id": "pid001",
//     "price": "\$1,250",
//     "owner_name": "Sangvaleap",
//     "owner_photo": profile,
//     "sex": "Male",
//     "age": "5 Months",
//     "color": "Brown",
//     "type": "Dog",
//     "album": [
//       "https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1537151625747-768eb6cf92b2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583511655826-05700d52f4d9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1591768575198-88dac53fbd0a?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     ]
//   },
//   {
//     "image":
//         "https://images.unsplash.com/photo-1598875184988-5e67b1a874b8?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     "name": "Meido",
//     "location": "Phnom Penh, Cambodia",
//     "is_favorited": false,
//     "description":
//         "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
//     "rate": 4.5,
//     "id": "pid001",
//     "price": "\$1,250",
//     "owner_name": "Sangvaleap",
//     "owner_photo": profile,
//     "sex": "Male",
//     "age": "5 Months",
//     "color": "Brown",
//     "type": "Dog",
//     "album": [
//       "https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1537151625747-768eb6cf92b2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583511655826-05700d52f4d9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1591768575198-88dac53fbd0a?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     ]
//   },
//   {
//     "image":
//         "https://images.unsplash.com/photo-1587764379873-97837921fd44?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     "name": "Koko",
//     "location": "Phnom Penh, Cambodia",
//     "is_favorited": false,
//     "description":
//         "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
//     "rate": 4.5,
//     "id": "pid001",
//     "price": "\$1,250",
//     "owner_name": "Sangvaleap",
//     "owner_photo": profile,
//     "sex": "Male",
//     "age": "5 Months",
//     "color": "Brown",
//     "type": "Dog",
//     "album": [
//       "https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1537151625747-768eb6cf92b2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583511655826-05700d52f4d9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1591768575198-88dac53fbd0a?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     ]
//   },
//   {
//     "image":
//         "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     "name": "Roka",
//     "location": "Phnom Penh, Cambodia",
//     "is_favorited": false,
//     "description":
//         "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
//     "rate": 4.5,
//     "id": "pid001",
//     "price": "\$1,250",
//     "owner_name": "Sangvaleap",
//     "owner_photo": profile,
//     "sex": "Male",
//     "age": "5 Months",
//     "color": "Brown",
//     "type": "Dog",
//     "album": [
//       "https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1537151625747-768eb6cf92b2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583511655826-05700d52f4d9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1591768575198-88dac53fbd0a?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//       "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
//     ]
//   },
//   {
//     "image":
//         "https://images.unsplash.com/photo-1721514011282-83c19a385a0f?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
//     "name": "Fluffy",
//     "location": "Paris, France",
//     "is_favorited": true,
//     "description":
//         "Fluffy is a very cute and affectionate cat who loves to sleep on laps.",
//     "rate": 4.5,
//     "id": "pid005",
//     "price": "\$500",
//     "owner_name": "Marie",
//     "owner_photo": "profile",
//     "sex": "Female",
//     "age": "2 Years",
//     "color": "Gray",
//     "type": "Cat",
//     "album": [
//       "https://images.unsplash.com/photo-1565706027-dc2ba774fe4e?crop=entropy&cs=tinysrgb&fit=max&ixid=MXwyMDg5NTh8MHx8Y2F0fGVufDB8fHx8fHwxNjEyNzE1NzMw&ixlib=rb-1.2.1&q=80&w=400",
//       "https://images.unsplash.com/photo-1600641248702-cd0bba68c7d9?crop=entropy&cs=tinysrgb&fit=max&ixid=MXwyMDg5NTh8MHx8Y2F0fGVufDB8fHx8fHwxNjEyNzE2NTI2&ixlib=rb-1.2.1&q=80&w=400",
//     ]
//   },
//   {
//     "image":
//         "https://images.unsplash.com/photo-1721560553266-feedece39fca?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
//     "name": "Luna",
//     "location": "San Francisco, USA",
//     "is_favorited": false,
//     "description":
//         "Luna loves playing around and chasing after balls. She is friendly and social with everyone.",
//     "rate": 4.0,
//     "id": "pid002",
//     "price": "\$800",
//     "owner_name": "Jessica",
//     "owner_photo": "profile",
//     "sex": "Female",
//     "age": "6 Months",
//     "color": "White",
//     "type": "Cat",
//     "album": [
//       "https://images.unsplash.com/photo-1562004741-c7d1a9b00bda?crop=entropy&cs=tinysrgb&fit=max&ixid=MXwyMDg5NTh8MHx8Y2F0fGVufDB8fHx8fHwxNjEyNzE2MTM1&ixlib=rb-1.2.1&q=80&w=400",
//       "https://images.unsplash.com/photo-1560732273-7a056ad1f4b3?crop=entropy&cs=tinysrgb&fit=max&ixid=MXwyMDg5NTh8MHx8Y2F0fGVufDB8fHx8fHwxNjEyNzE1NDA3&ixlib=rb-1.2.1&q=80&w=400",
//     ]
//   },
//   {
//     "image":
//         "https://images.unsplash.com/photo-1552728089-57bdde30beb3?q=80&w=1925&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
//     "name": "Pecky",
//     "location": "Melbourne, Australia",
//     "is_favorited": false,
//     "description":
//         "Pecky loves flying around and interacting with new people. He’s very friendly and loves talking!",
//     "rate": 5.0,
//     "id": "pid003",
//     "price": "\$350",
//     "owner_name": "Oliver",
//     "owner_photo": "profile",
//     "sex": "Male",
//     "age": "1 Year",
//     "color": "Green",
//     "type": "Parrot",
//     "album": [
//       "https://images.unsplash.com/photo-1598150602414-47fbb29963b6?crop=entropy&cs=tinysrgb&fit=max&ixid=MXwyMDg5NTh8MHx8Y2F0fGVufDB8fHx8fHwxNjEyNzE2MzMw&ixlib=rb-1.2.1&q=80&w=400",
//       "https://images.unsplash.com/photo-1562268687-198ff422d3be?crop=entropy&cs=tinysrgb&fit=max&ixid=MXwyMDg5NTh8MHx8YmlyZDx8fDJ8fHx8fHwxNjEyNzE2MzMw&ixlib=rb-1.2.1&q=80&w=400",
//     ]
//   },
// ];

var chats = [
  {
    "image":
        "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjV8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "fname": "John",
    "lname": "Siphron",
    "name": "John Siphron",
    "skill": "Dermatologists",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "1 min",
    "notify": 4,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "fname": "Corey",
    "lname": "Aminoff",
    "name": "Corey Aminoff",
    "skill": "Neurologists",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "3 min",
    "notify": 2,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1617069470302-9b5592c80f66?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "fname": "Siriya",
    "lname": "Aminoff",
    "name": "Siriya Aminoff",
    "skill": "Neurologists",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "1 hr",
    "notify": 1,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1545167622-3a6ac756afa4?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTB8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "fname": "Rubin",
    "lname": "Joe",
    "name": "Rubin Joe",
    "skill": "Neurologists",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "1 hr",
    "notify": 1,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1564460576398-ef55d99548b2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "fname": "John",
    "lname": "",
    "name": "DentTerry Jew",
    "skill": "Dentist",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "2 hrs",
    "notify": 0,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1622253692010-333f2da6031d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=928&q=80",
    "fname": "John",
    "lname": "",
    "name": "Corey Aminoff",
    "skill": "Neurologists",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "5 hrs",
    "notify": 0,
  },
];
