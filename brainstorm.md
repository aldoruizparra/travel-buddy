# Step 1: Generate new ideas
## 1. Travel Buddy
**Core Idea:**  
Add and track shared travel expenses in different currencies, split between group members.

**Skills & Tools Needed:**  
- API integration for currency conversion (e.g., OpenExchangeRates or similar).  
- UITableView for displaying expenses.  
- UserDefaults or Core Data for saving expenses.  
- Basic math for cost splitting logic.  


## 2. Task Manager with Photos
**Core Idea:**  
A to-do list where tasks can include photos and be assigned to people.

**Skills & Tools Needed:**  
- UITableView with custom cells for task display.  
- UIImagePickerController for camera/photo library access.  
- Data modeling for task assignment.  
- UserDefaults or Core Data for task persistence.  


## 3. Recipe & Grocery Planner
**Core Idea:**  
Store favorite recipes, generate a grocery list from them, and mark items as bought.

**Skills & Tools Needed:**  
- UITableView & UICollectionView for recipes and ingredients.  
- Local storage (UserDefaults/Core Data) for saving recipes.  
- Optional API integration for fetching recipes.  
- Checklists for managing grocery items.  


## 4. Simple Expense Tracker
**Core Idea:**  
Track personal expenses with categories (food, transport, entertainment) and view a basic summary.

**Skills & Tools Needed:**  
- UITableView for transactions.  
- UIPickerView for category selection.  
- UserDefaults for storing expense data.  

## 5. Workout Log
**Core Idea:**  
Log your workouts (type, duration, notes) and view your history.

**Skills & Tools Needed:**  
- Forms with UITextField and UIPickerView for workout details.  
- UITableView for displaying workout history.  
- UserDefaults or Core Data for saving workout logs.  

## 6. Meal Planner
**Core Idea:**  
Plan meals for the week and create a simple grocery checklist.

**Skills & Tools Needed:**  
- UISegmentedControl for meal types (breakfast, lunch, dinner).  
- Checklists for grocery planning.  
- Editable UITableView for meal and grocery management.  


## 7. Random Recipe App
**Core Idea:**  
Generate a random recipe or search by ingredient.

**APIs:**  
- [TheMealDB API](https://www.themealdb.com/) for recipes.  

**Skills & Tools Needed:**  
- API integration to fetch random or ingredient-based recipes.  
- Displaying images and instructions in a detailed view.  
- Share functionality (UIActivityViewController) to send recipes via text or email.  

# Step 2: Evaluating App Ideas

## 2.1 My top 2.
1. Travel Buddy (With Expenses)
2. Random Recipe App

## Step 2.2: Evaluating Ideas

We evaluate each app using the following criteria:  
**Mobile, Story, Market, Habit, Scope**


### **1. Travel Buddy**

**Mobile:**  
- Uses API for real-time currency conversion.  
- Potential to use camera (for receipt photos) and location (to auto-detect currency).  
- Push notifications possible for expense reminders.  

**Story:**  
- Highly compelling for group travelers.  
- Clear value: “Easily track and split costs with friends.”  
- Strong peer response potential.  

**Market:**  
- Strong niche audience: travelers, students abroad, group vacationers.  
- High value for its audience, even if niche.  

**Habit:**  
- Used frequently during trips (multiple times a day).  
- Limited use outside of travel periods.   

**Scope:**  
- Core MVP (add expenses, split costs, save locally) is achievable.  
- Advanced features (currency API, notifications) can be added later.  


### **2. Random Recipe App**

**Mobile:**  
- Uses API to fetch recipes.  
- Could integrate sharing or camera features, but primarily data consumption.  

**Story:**  
- Fun and casual: “Get a random meal idea or search by ingredients you have.”  
- Appeals to anyone interested in cooking.  

**Market:**  
- Large potential audience (home cooks, meal planners).  
- Many existing recipe apps; needs a unique hook.  

**Habit:**  
- Could be opened daily for meal inspiration.  
- Higher habit potential with features like “meal of the day” notifications.  

**Scope:**  
- Simple MVP (fetch & display recipes) is very doable.  
- Advanced features like sharing and saving favorites can be added later.  



## Step 2.3: The Final Decision

**Decision:**  
**Build Travel Buddy**

**Reasoning**  
- It’s **uniquely mobile** (currency conversion, potential for camera/location features).  
- It has a **clear and compelling story**: “Make trips stress-free by tracking shared expenses.”  
- It has a **well-scoped MVP** that feels impactful even without advanced features.  

   


