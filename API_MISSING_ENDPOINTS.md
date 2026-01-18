# Missing API Endpoints - TybeToGo Driver App

This document outlines all the missing API endpoints needed for the driver application to function properly.

---

## 📱 **HOME SCREEN ENDPOINTS**

### 1. Get Driver Status
**Endpoint:** `GET /api/drivers/status/`

**Why it's needed:**
- When the driver opens the app, we need to know if they're currently online or offline
- Prevents state mismatch between app and server
- Shows last active timestamp for reporting

**Use case:**
- Called when the home screen loads
- Used to initialize the online/offline toggle button state

**Request:**
```http
GET /api/drivers/status/
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "id": 123,
  "is_online": true,
  "last_active_at": "2026-01-10T14:30:00Z",
  "current_location": {
    "latitude": 52.5200,
    "longitude": 13.4050
  }
}
```

**Response Fields:**
- `is_online` (boolean): Current online/offline status
- `last_active_at` (datetime): Last time driver was active
- `current_location` (object, optional): Last known GPS coordinates

---

### 2. Get Today's Stats
**Endpoint:** `GET /api/drivers/stats/today/`

**Why it's needed:**
- Home screen displays today's performance metrics
- Shows: total orders, earnings, hours online, rating
- Motivates drivers to see their daily progress
- Real-time updates as they complete deliveries

**Use case:**
- Called when home screen loads
- Refreshed after completing each order
- Updates the 4 stat cards on home screen

**Request:**
```http
GET /api/drivers/stats/today/
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "date": "2026-01-10",
  "total_orders": 12,
  "total_earnings": 245.50,
  "hours_online": 4.2,
  "current_rating": 4.9,
  "breakdown": {
    "delivery_fees": 186.00,
    "tips": 59.50
  }
}
```

**Response Fields:**
- `total_orders` (integer): Number of completed orders today
- `total_earnings` (decimal): Total money earned today (delivery fees + tips)
- `hours_online` (decimal): Hours spent online today
- `current_rating` (decimal): Driver's current rating (0-5)
- `breakdown.delivery_fees` (decimal): Total from delivery fees
- `breakdown.tips` (decimal): Total from customer tips

---

### 3. Get Active Order
**Endpoint:** `GET /api/drivers/active-order/`

**Why it's needed:**
- Driver needs to see their current ongoing delivery
- Shows order details, pickup/dropoff locations, customer info
- Displays order status and navigation options
- Used on both Home screen and Orders screen

**Use case:**
- Called when home screen loads to check if driver has an active delivery
- Polled periodically to check for status updates
- Shows the order card with "Continue Delivery" button

**Request:**
```http
GET /api/drivers/active-order/
Authorization: Bearer {access_token}
```

**Response (when active order exists):**
```json
{
  "id": 456,
  "order_type": "FOOD",
  "status": "PICKED_UP",
  "restaurant_name": "Burger King",
  "customer_name": "John D.",
  "pickup_address": "Alexanderplatz 1, 10178 Berlin",
  "dropoff_address": "Friedrichstraße 123, 10117 Berlin",
  "total_amount": 25.34,
  "delivery_fee": 6.50,
  "tip": 2.00,
  "calculated_distance": 3200,
  "calculated_time": 900,
  "requested_vehicle_type": "BIKE",
  "created_at": "2026-01-10T14:15:00Z",
  "accepted_at": "2026-01-10T14:16:30Z",
  "distance": "3.2 km",
  "items": [
    "2x Whopper",
    "1x Fries",
    "1x Coke"
  ],
  "pickup_location": {
    "latitude": 52.5219,
    "longitude": 13.4132
  },
  "dropoff_location": {
    "latitude": 52.5200,
    "longitude": 13.3889
  },
  "customer_phone": "+49123456789",
  "special_instructions": "Ring doorbell twice"
}
```

**Response (when no active order):**
```json
{
  "active_order": null
}
```

**Response Fields:**
- `id` (integer): Unique order ID
- `status` (string): Order status (PENDING, ACCEPTED, PICKED_UP, IN_PROGRESS, DELIVERED, COMPLETED)
- `restaurant_name` (string): Pickup location name
- `customer_name` (string): Customer's name
- `pickup_address` (string): Full pickup address
- `dropoff_address` (string): Full delivery address
- `delivery_fee` (decimal): Driver's earning from this delivery
- `tip` (decimal): Customer tip amount
- `calculated_distance` (integer): Distance in meters
- `calculated_time` (integer): Estimated time in seconds
- `items` (array): List of ordered items
- `pickup_location` (object): GPS coordinates for pickup
- `dropoff_location` (object): GPS coordinates for dropoff
- `customer_phone` (string): Customer contact number
- `special_instructions` (string, optional): Delivery notes

---

### 4. Get Recent Orders
**Endpoint:** `GET /api/drivers/recent-orders/`

**Why it's needed:**
- Home screen shows "Recent Orders" section
- Displays last 5 completed deliveries
- Provides quick access to order history
- Shows order summary (customer, earnings, time)

**Use case:**
- Called when home screen loads
- Shows recent activity to the driver
- "See All" button navigates to full order history

**Request:**
```http
GET /api/drivers/recent-orders/?limit=5
Authorization: Bearer {access_token}
```

**Query Parameters:**
- `limit` (integer, optional): Number of orders to return (default: 5)

**Response:**
```json
{
  "results": [
    {
      "id": 445,
      "order_type": "FOOD",
      "status": "COMPLETED",
      "restaurant_name": "McDonald's",
      "customer_name": "Sarah M.",
      "pickup_address": "Potsdamer Platz 1, Berlin",
      "dropoff_address": "Unter den Linden 77, Berlin",
      "total_amount": 18.50,
      "delivery_fee": 5.00,
      "tip": 1.50,
      "distance": "2.1 km",
      "completed_at": "2026-01-10T13:45:00Z",
      "created_at": "2026-01-10T13:20:00Z"
    },
    {
      "id": 444,
      "order_type": "FOOD",
      "status": "COMPLETED",
      "restaurant_name": "Pizza Hut",
      "customer_name": "Mike T.",
      "pickup_address": "Kurfürstendamm 15, Berlin",
      "dropoff_address": "Savignyplatz 3, Berlin",
      "total_amount": 32.00,
      "delivery_fee": 7.00,
      "tip": 3.00,
      "distance": "4.5 km",
      "completed_at": "2026-01-10T12:30:00Z",
      "created_at": "2026-01-10T12:00:00Z"
    }
  ]
}
```

---

## 📦 **ORDERS SCREEN ENDPOINTS**

### 5. Get Order History
**Endpoint:** `GET /api/drivers/order-history/`

**Why it's needed:**
- Orders screen has a "History" tab showing all past deliveries
- Needs pagination for performance (drivers may have hundreds of orders)
- Allows filtering by status (completed, cancelled)
- Shows full order history with search/filter capabilities

**Use case:**
- Called when user switches to "Order History" tab
- Implements infinite scroll or pagination
- Shows completed and cancelled orders

**Request:**
```http
GET /api/drivers/order-history/?page=1&limit=20&status=COMPLETED
Authorization: Bearer {access_token}
```

**Query Parameters:**
- `page` (integer, optional): Page number (default: 1)
- `limit` (integer, optional): Orders per page (default: 20)
- `status` (string, optional): Filter by status (COMPLETED, CANCELLED, ALL)
- `start_date` (date, optional): Filter from date (YYYY-MM-DD)
- `end_date` (date, optional): Filter to date (YYYY-MM-DD)

**Response:**
```json
{
  "count": 156,
  "next": "http://api.example.org/api/drivers/order-history/?page=2",
  "previous": null,
  "results": [
    {
      "id": 445,
      "order_type": "FOOD",
      "status": "COMPLETED",
      "restaurant_name": "McDonald's",
      "customer_name": "Sarah M.",
      "pickup_address": "Potsdamer Platz 1, Berlin",
      "dropoff_address": "Unter den Linden 77, Berlin",
      "total_amount": 18.50,
      "delivery_fee": 5.00,
      "tip": 1.50,
      "calculated_distance": 2100,
      "calculated_time": 720,
      "distance": "2.1 km",
      "created_at": "2026-01-10T13:20:00Z",
      "accepted_at": "2026-01-10T13:21:00Z",
      "completed_at": "2026-01-10T13:45:00Z"
    }
  ]
}
```

**Response Fields:**
- `count` (integer): Total number of orders
- `next` (string, nullable): URL for next page
- `previous` (string, nullable): URL for previous page
- `results` (array): Array of order objects

---

### 6. Get Aggregated Stats
**Endpoint:** `GET /api/drivers/stats/`

**Why it's needed:**
- Order History tab shows summary stats at the top
- Displays total orders, total earnings, average delivery time
- Allows filtering by period (today, week, month)
- Provides performance overview

**Use case:**
- Called when Order History tab loads
- Shows summary cards above the order list
- Updates when user changes period filter

**Request:**
```http
GET /api/drivers/stats/?period=week
Authorization: Bearer {access_token}
```

**Query Parameters:**
- `period` (string, optional): Time period - "today", "week", "month", "all" (default: "today")
- `start_date` (date, optional): Custom start date (YYYY-MM-DD)
- `end_date` (date, optional): Custom end date (YYYY-MM-DD)

**Response:**
```json
{
  "period": "week",
  "start_date": "2026-01-04",
  "end_date": "2026-01-10",
  "total_orders": 47,
  "total_earnings": 1245.50,
  "average_delivery_time": 22,
  "total_distance": 156.8,
  "total_tips": 124.00,
  "breakdown": {
    "completed": 45,
    "cancelled": 2,
    "delivery_fees": 1121.50,
    "tips": 124.00
  }
}
```

**Response Fields:**
- `total_orders` (integer): Total completed orders in period
- `total_earnings` (decimal): Total earnings (fees + tips)
- `average_delivery_time` (integer): Average time in minutes
- `total_distance` (decimal): Total kilometers traveled
- `total_tips` (decimal): Total tips received
- `breakdown` (object): Detailed statistics

---

## 📋 **ORDER DETAIL SCREEN ENDPOINTS**

### 7. Get Order Details
**Endpoint:** `GET /api/orders/{orderId}/`

**Why it's needed:**
- When driver taps on an order, they need full details
- Shows complete information: items, addresses, customer info, earnings
- Provides navigation and contact options
- Displays order timeline (accepted, picked up, delivered times)

**Use case:**
- Called when driver taps an order card
- Shows order detail screen with all information
- Allows driver to view past order details

**Request:**
```http
GET /api/orders/456/
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "id": 456,
  "order_type": "FOOD",
  "status": "IN_PROGRESS",
  "restaurant_name": "Burger King",
  "customer_name": "John D.",
  "customer_phone": "+49123456789",
  "pickup_address": "Alexanderplatz 1, 10178 Berlin",
  "dropoff_address": "Friedrichstraße 123, 10117 Berlin",
  "total_amount": 25.34,
  "delivery_fee": 6.50,
  "tip": 2.00,
  "calculated_distance": 3200,
  "calculated_time": 900,
  "distance": "3.2 km",
  "estimated_time": "15 min",
  "items": [
    {
      "name": "Whopper",
      "quantity": 2,
      "price": 8.99
    },
    {
      "name": "Fries",
      "quantity": 1,
      "price": 2.49
    },
    {
      "name": "Coke",
      "quantity": 1,
      "price": 1.99
    }
  ],
  "pickup_location": {
    "latitude": 52.5219,
    "longitude": 13.4132,
    "address": "Alexanderplatz 1, 10178 Berlin"
  },
  "dropoff_location": {
    "latitude": 52.5200,
    "longitude": 13.3889,
    "address": "Friedrichstraße 123, 10117 Berlin"
  },
  "special_instructions": "Ring doorbell twice, apartment 3B",
  "requested_vehicle_type": "BIKE",
  "created_at": "2026-01-10T14:15:00Z",
  "accepted_at": "2026-01-10T14:16:30Z",
  "picked_up_at": "2026-01-10T14:25:00Z",
  "delivered_at": null,
  "completed_at": null,
  "cancelled_at": null,
  "timeline": [
    {
      "status": "PENDING",
      "timestamp": "2026-01-10T14:15:00Z"
    },
    {
      "status": "ACCEPTED",
      "timestamp": "2026-01-10T14:16:30Z"
    },
    {
      "status": "PICKED_UP",
      "timestamp": "2026-01-10T14:25:00Z"
    }
  ]
}
```

**Response Fields:**
- All fields from order list, plus:
- `items` (array): Detailed list of ordered items with quantities
- `pickup_location` (object): Full pickup location details
- `dropoff_location` (object): Full dropoff location details
- `special_instructions` (string): Customer delivery notes
- `timeline` (array): Order status history with timestamps
- `picked_up_at`, `delivered_at`, `completed_at` (datetime): Status timestamps

---

### 8. Get Navigation Data (Optional but Recommended)
**Endpoint:** `GET /api/orders/{orderId}/navigation/`

**Why it's needed:**
- Provides coordinates for GPS navigation
- Returns optimized route information
- May include waypoints, distance, estimated time
- Integrates with maps app (Google Maps, Apple Maps)

**Use case:**
- Called when driver taps "Start Navigation" button
- Gets accurate coordinates for pickup and dropoff
- Can return route optimization data

**Request:**
```http
GET /api/orders/456/navigation/
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "order_id": 456,
  "pickup": {
    "latitude": 52.5219,
    "longitude": 13.4132,
    "address": "Alexanderplatz 1, 10178 Berlin",
    "name": "Burger King"
  },
  "dropoff": {
    "latitude": 52.5200,
    "longitude": 13.3889,
    "address": "Friedrichstraße 123, 10117 Berlin",
    "name": "Customer Location"
  },
  "route": {
    "distance": 3200,
    "duration": 900,
    "polyline": "encoded_polyline_string_here"
  }
}
```

**Note:** If this endpoint is not available, the app can use `pickup_location` and `dropoff_location` from the order details endpoint and construct the navigation URL client-side.

---

### 9. Get Customer Contact (Optional)
**Endpoint:** `GET /api/orders/{orderId}/customer-contact/`

**Why it's needed:**
- Driver may need to call customer for directions or access codes
- Provides customer phone number securely
- May use proxy number for privacy
- Logs contact attempts for support

**Use case:**
- Called when driver taps "Call Customer" button
- Returns phone number to dial
- May track communication for safety

**Request:**
```http
GET /api/orders/456/customer-contact/
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "order_id": 456,
  "customer_name": "John D.",
  "phone_number": "+49123456789",
  "can_call": true,
  "call_method": "direct",
  "privacy_note": "Customer phone number is visible only during active delivery"
}
```

**Alternative (if using proxy numbers):**
```json
{
  "order_id": 456,
  "customer_name": "John D.",
  "phone_number": "+49800PROXY123",
  "can_call": true,
  "call_method": "proxy",
  "privacy_note": "Using proxy number to protect customer privacy"
}
```

**Note:** If this endpoint is not available, the app can use `customer_phone` from the order details endpoint.

---

## 💰 **EARNINGS SCREEN ENDPOINTS**

### 10. Get Earnings by Period
**Endpoint:** `GET /api/drivers/earnings/`

**Why it's needed:**
- Earnings screen is entirely dependent on this data
- Shows total earnings, orders, tips, hours for selected period
- Provides daily/weekly/monthly breakdown charts
- Displays growth percentage compared to previous period
- Essential for driver payment transparency

**Use case:**
- Called when earnings screen loads
- Refreshed when user changes period (today/week/month)
- Updates after completing orders
- Shows detailed earnings breakdown

**Request:**
```http
GET /api/drivers/earnings/?period=week
Authorization: Bearer {access_token}
```

**Query Parameters:**
- `period` (string): Time period - "today", "week", "month"
- `start_date` (date, optional): Custom start date (YYYY-MM-DD)
- `end_date` (date, optional): Custom end date (YYYY-MM-DD)

**Response:**
```json
{
  "period": "week",
  "start_date": "2026-01-04",
  "end_date": "2026-01-10",
  "total_earnings": 1245.50,
  "total_orders": 47,
  "total_tips": 124.00,
  "hours_online": 32.5,
  "average_per_order": 26.50,
  "delivery_fees": 1121.50,
  "growth_percentage": 12.5,
  "comparison": {
    "previous_period_earnings": 1108.00,
    "difference": 137.50,
    "percentage_change": 12.5
  },
  "daily_breakdown": [
    {
      "date": "2026-01-04",
      "earnings": 185.50,
      "orders": 7,
      "tips": 18.50,
      "hours": 4.5
    },
    {
      "date": "2026-01-05",
      "earnings": 210.00,
      "orders": 8,
      "tips": 22.00,
      "hours": 5.0
    },
    {
      "date": "2026-01-06",
      "earnings": 195.00,
      "orders": 7,
      "tips": 19.00,
      "hours": 4.8
    },
    {
      "date": "2026-01-07",
      "earnings": 175.00,
      "orders": 6,
      "tips": 15.00,
      "hours": 4.2
    },
    {
      "date": "2026-01-08",
      "earnings": 165.00,
      "orders": 6,
      "tips": 17.50,
      "hours": 4.0
    },
    {
      "date": "2026-01-09",
      "earnings": 155.00,
      "orders": 6,
      "tips": 16.00,
      "hours": 4.5
    },
    {
      "date": "2026-01-10",
      "earnings": 160.00,
      "orders": 7,
      "tips": 16.00,
      "hours": 5.5
    }
  ]
}
```

**Response Fields:**
- `total_earnings` (decimal): Total money earned in period
- `total_orders` (integer): Number of completed orders
- `total_tips` (decimal): Total tips received
- `hours_online` (decimal): Total hours online
- `average_per_order` (decimal): Average earning per order
- `delivery_fees` (decimal): Total delivery fees (excluding tips)
- `growth_percentage` (decimal): Growth compared to previous period
- `comparison` (object): Comparison with previous period
- `daily_breakdown` (array): Day-by-day breakdown for charts

---

### 11. Get Payslips
**Endpoint:** `GET /api/drivers/payslips/`

**Why it's needed:**
- Drivers need access to their payment history
- Provides official earning statements
- Required for tax purposes
- Shows payout dates and amounts

**Use case:**
- Called when user taps "View Payslips" on earnings screen
- Lists all available payslips
- Allows downloading individual payslips

**Request:**
```http
GET /api/drivers/payslips/
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "results": [
    {
      "id": 123,
      "period_start": "2026-01-01",
      "period_end": "2026-01-07",
      "total_earnings": 1108.00,
      "orders": 42,
      "payout_amount": 996.20,
      "payout_date": "2026-01-10",
      "status": "PAID",
      "download_url": "https://api.example.org/api/drivers/payslips/123/download/"
    },
    {
      "id": 122,
      "period_start": "2025-12-25",
      "period_end": "2025-12-31",
      "total_earnings": 980.50,
      "orders": 38,
      "payout_amount": 882.45,
      "payout_date": "2026-01-03",
      "status": "PAID",
      "download_url": "https://api.example.org/api/drivers/payslips/122/download/"
    }
  ]
}
```

**Response Fields:**
- `period_start`, `period_end` (date): Earning period
- `total_earnings` (decimal): Total earned in period
- `orders` (integer): Number of orders completed
- `payout_amount` (decimal): Amount paid (after fees/deductions)
- `payout_date` (date): When payment was made
- `status` (string): PENDING, PROCESSING, PAID
- `download_url` (string): URL to download PDF payslip

---

### 12. Download Payslip
**Endpoint:** `GET /api/drivers/payslips/{payslipId}/download/`

**Why it's needed:**
- Allows drivers to download PDF payslips
- Required for tax filing and record keeping
- Provides official payment documentation

**Use case:**
- Called when user taps on a payslip to download
- Returns PDF file or redirect URL

**Request:**
```http
GET /api/drivers/payslips/123/download/
Authorization: Bearer {access_token}
```

**Response:**
- Content-Type: `application/pdf`
- Binary PDF file
- OR redirect to signed S3/storage URL

---

## 👤 **PROFILE SCREEN ENDPOINTS**

### 13. Get Driver Profile
**Endpoint:** `GET /api/drivers/profile/`

**Why it's needed:**
- Profile screen displays driver information
- Shows name, phone, email, avatar, rating
- Displays total orders and earnings since joining
- Shows member since date
- Required to populate profile header and stats

**Use case:**
- Called when profile screen loads
- Updates after profile edits
- Shows driver's complete information

**Request:**
```http
GET /api/drivers/profile/
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "id": 789,
  "first_name": "John",
  "last_name": "Driver",
  "full_name": "John Driver",
  "phone": "+49123456789",
  "email": "john.driver@example.com",
  "avatar": "https://storage.example.com/avatars/john.jpg",
  "rating": 4.9,
  "total_orders": 1234,
  "total_earnings": 12450.00,
  "member_since": "2024-01-15",
  "status": "ACTIVE",
  "verification_status": "VERIFIED",
  "vehicle_info": {
    "type": "BIKE",
    "make": "Yamaha",
    "model": "MT-07",
    "year": 2022,
    "plate": "B-XY 1234",
    "color": "Black"
  },
  "documents": {
    "license": {
      "status": "APPROVED",
      "expiry_date": "2027-06-15"
    },
    "insurance": {
      "status": "APPROVED",
      "expiry_date": "2026-12-31"
    },
    "registration": {
      "status": "APPROVED",
      "expiry_date": "2027-03-20"
    }
  }
}
```

**Response Fields:**
- `full_name` (string): Driver's full name
- `phone` (string): Phone number
- `email` (string, optional): Email address
- `avatar` (string, optional): Profile picture URL
- `rating` (decimal): Current rating (0-5)
- `total_orders` (integer): Lifetime orders completed
- `total_earnings` (decimal): Lifetime earnings
- `member_since` (date): Registration date
- `vehicle_info` (object): Vehicle details
- `documents` (object): Document verification status

---

### 14. Update Driver Profile
**Endpoint:** `PUT /api/drivers/profile/` or `PATCH /api/drivers/profile/`

**Why it's needed:**
- Allows drivers to edit their profile information
- Update name, email, avatar
- Modify contact information
- Keep profile data current

**Use case:**
- Called when driver saves profile changes
- Updates name, email, or avatar
- Validates and saves changes

**Request:**
```http
PATCH /api/drivers/profile/
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "first_name": "John",
  "last_name": "Driver",
  "email": "newemail@example.com"
}
```

**For avatar upload (multipart/form-data):**
```http
PUT /api/drivers/profile/avatar/
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

avatar: [binary file data]
```

**Response:**
```json
{
  "id": 789,
  "first_name": "John",
  "last_name": "Driver",
  "full_name": "John Driver",
  "email": "newemail@example.com",
  "avatar": "https://storage.example.com/avatars/john.jpg",
  "updated_at": "2026-01-10T15:30:00Z"
}
```

---

### 15. Get Driver Documents
**Endpoint:** `GET /api/drivers/documents/`

**Why it's needed:**
- Shows status of required documents (license, insurance, registration)
- Displays expiry dates and verification status
- Alerts driver about expiring documents
- Required for compliance

**Use case:**
- Called when user taps "Documents" in profile menu
- Shows document list with status
- Allows uploading new documents

**Request:**
```http
GET /api/drivers/documents/
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "documents": [
    {
      "id": 1,
      "type": "DRIVERS_LICENSE",
      "name": "Driver's License",
      "status": "APPROVED",
      "uploaded_at": "2024-01-15T10:00:00Z",
      "verified_at": "2024-01-16T14:30:00Z",
      "expiry_date": "2027-06-15",
      "file_url": "https://storage.example.com/docs/license_123.pdf",
      "notes": null
    },
    {
      "id": 2,
      "type": "INSURANCE",
      "name": "Vehicle Insurance",
      "status": "APPROVED",
      "uploaded_at": "2024-01-15T10:05:00Z",
      "verified_at": "2024-01-16T14:35:00Z",
      "expiry_date": "2026-12-31",
      "file_url": "https://storage.example.com/docs/insurance_123.pdf",
      "notes": null
    },
    {
      "id": 3,
      "type": "VEHICLE_REGISTRATION",
      "name": "Vehicle Registration",
      "status": "EXPIRED",
      "uploaded_at": "2024-01-15T10:10:00Z",
      "verified_at": "2024-01-16T14:40:00Z",
      "expiry_date": "2026-01-05",
      "file_url": "https://storage.example.com/docs/registration_123.pdf",
      "notes": "Please upload renewed registration"
    }
  ]
}
```

**Document Status Values:**
- `PENDING` - Uploaded, awaiting verification
- `APPROVED` - Verified and active
- `REJECTED` - Not accepted, needs reupload
- `EXPIRED` - Document has expired
- `MISSING` - Required document not uploaded

---

### 16. Upload/Update Document
**Endpoint:** `POST /api/drivers/documents/` or `PUT /api/drivers/documents/{documentId}/`

**Why it's needed:**
- Drivers need to upload required documents
- Update expired documents
- Maintain compliance with regulations
- Submit documents for verification

**Use case:**
- Called when driver uploads a new document
- Updates existing expired documents
- Supports PDF, JPG, PNG formats

**Request (Upload new):**
```http
POST /api/drivers/documents/
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

type: "DRIVERS_LICENSE"
file: [binary file data]
expiry_date: "2027-06-15"
```

**Request (Update existing):**
```http
PUT /api/drivers/documents/3/
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

file: [binary file data]
expiry_date: "2027-03-20"
```

**Response:**
```json
{
  "id": 3,
  "type": "VEHICLE_REGISTRATION",
  "name": "Vehicle Registration",
  "status": "PENDING",
  "uploaded_at": "2026-01-10T15:45:00Z",
  "verified_at": null,
  "expiry_date": "2027-03-20",
  "file_url": "https://storage.example.com/docs/registration_456.pdf",
  "notes": null
}
```

---

### 17. Get Vehicle Info
**Endpoint:** `GET /api/drivers/vehicle/`

**Why it's needed:**
- Shows vehicle information on profile
- Displays vehicle type, make, model, plate
- Required for order matching (vehicle type)
- Needed for insurance and compliance

**Use case:**
- Called when user taps "Vehicle Info" in profile
- Shows current vehicle details
- Allows editing vehicle information

**Request:**
```http
GET /api/drivers/vehicle/
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "id": 1,
  "type": "BIKE",
  "make": "Yamaha",
  "model": "MT-07",
  "year": 2022,
  "plate": "B-XY 1234",
  "color": "Black",
  "insurance_expiry": "2026-12-31",
  "registration_expiry": "2027-03-20",
  "status": "ACTIVE"
}
```

**Vehicle Types:**
- `BIKE` - Motorcycle/Scooter
- `BICYCLE` - Bicycle
- `CAR` - Car
- `VAN` - Van

---

### 18. Update Vehicle Info
**Endpoint:** `PUT /api/drivers/vehicle/` or `PATCH /api/drivers/vehicle/`

**Why it's needed:**
- Drivers can update vehicle details
- Change vehicle when switching
- Update registration plate, color, etc.
- Keep vehicle info current

**Use case:**
- Called when driver saves vehicle changes
- Updates vehicle details
- May trigger re-verification

**Request:**
```http
PATCH /api/drivers/vehicle/
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "make": "Honda",
  "model": "CB500X",
  "color": "Red",
  "plate": "B-XY 5678"
}
```

**Response:**
```json
{
  "id": 1,
  "type": "BIKE",
  "make": "Honda",
  "model": "CB500X",
  "year": 2022,
  "plate": "B-XY 5678",
  "color": "Red",
  "updated_at": "2026-01-10T16:00:00Z"
}
```

---

## 🔔 **NOTIFICATIONS SCREEN ENDPOINTS**

### 19. Get Notifications
**Endpoint:** `GET /api/notifications/`

**Why it's needed:**
- Notifications screen displays all notifications
- Shows order updates, system alerts, earnings updates
- Supports pagination for performance
- Tracks read/unread status
- Provides notification history

**Use case:**
- Called when notifications screen loads
- Implements pull-to-refresh
- Shows unread count badge
- Displays notification list

**Request:**
```http
GET /api/notifications/?page=1&limit=20&unread_only=false
Authorization: Bearer {access_token}
```

**Query Parameters:**
- `page` (integer, optional): Page number
- `limit` (integer, optional): Notifications per page
- `unread_only` (boolean, optional): Show only unread notifications

**Response:**
```json
{
  "count": 45,
  "unread_count": 3,
  "next": "http://api.example.org/api/notifications/?page=2",
  "previous": null,
  "results": [
    {
      "id": 789,
      "type": "ORDER_COMPLETED",
      "title": "Order completed",
      "message": "You earned $8.50 from order #456",
      "data": {
        "order_id": 456,
        "earnings": 8.50
      },
      "is_read": false,
      "created_at": "2026-01-10T14:45:00Z",
      "read_at": null
    },
    {
      "id": 788,
      "type": "NEW_ORDER",
      "title": "New order available",
      "message": "New order from Burger King - $6.50",
      "data": {
        "order_id": 455,
        "restaurant": "Burger King"
      },
      "is_read": true,
      "created_at": "2026-01-10T14:15:00Z",
      "read_at": "2026-01-10T14:16:00Z"
    },
    {
      "id": 787,
      "type": "EARNINGS_UPDATE",
      "title": "Weekly earnings summary",
      "message": "You earned $1,245.50 this week!",
      "data": {
        "period": "week",
        "earnings": 1245.50
      },
      "is_read": true,
      "created_at": "2026-01-10T00:00:00Z",
      "read_at": "2026-01-10T08:30:00Z"
    }
  ]
}
```

**Notification Types:**
- `NEW_ORDER` - New order available
- `ORDER_ACCEPTED` - Order accepted
- `ORDER_CANCELLED` - Order cancelled
- `ORDER_COMPLETED` - Order completed
- `EARNINGS_UPDATE` - Earnings summary
- `DOCUMENT_EXPIRING` - Document expiring soon
- `SYSTEM_ALERT` - System announcements

---

### 20. Mark Notification as Read
**Endpoint:** `PUT /api/notifications/{notificationId}/read/`

**Why it's needed:**
- Marks individual notification as read
- Updates unread count badge
- Tracks which notifications user has seen

**Use case:**
- Called when user taps on a notification
- Automatically marks as read when opened
- Updates UI read status

**Request:**
```http
PUT /api/notifications/789/read/
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "id": 789,
  "is_read": true,
  "read_at": "2026-01-10T16:30:00Z"
}
```

---

### 21. Mark All Notifications as Read
**Endpoint:** `POST /api/notifications/read-all/`

**Why it's needed:**
- Convenience feature to mark all as read
- Clears unread count badge
- Improves user experience

**Use case:**
- Called when user taps "Mark all as read" button
- Batch operation for better performance
- Updates all unread notifications

**Request:**
```http
POST /api/notifications/read-all/
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "success": true,
  "marked_count": 3,
  "unread_count": 0
}
```

---

### 22. Delete Notification
**Endpoint:** `DELETE /api/notifications/{notificationId}/`

**Why it's needed:**
- Allows users to delete notifications
- Cleans up notification list
- Removes old/unwanted notifications

**Use case:**
- Called when user swipes to delete notification
- Removes notification from list
- Permanent deletion

**Request:**
```http
DELETE /api/notifications/789/
Authorization: Bearer {access_token}
```

**Response:**
```http
HTTP 204 No Content
```

---

## ⚙️ **SETTINGS SCREEN ENDPOINTS**

### 23. Get Driver Settings/Preferences
**Endpoint:** `GET /api/drivers/settings/`

**Why it's needed:**
- Retrieves driver's preferences
- Shows notification settings
- Language and theme preferences
- Other app settings

**Use case:**
- Called when settings screen loads
- Displays current settings
- Syncs settings across devices

**Request:**
```http
GET /api/drivers/settings/
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "notifications": {
    "push_enabled": true,
    "email_enabled": false,
    "sms_enabled": false,
    "new_orders": true,
    "order_updates": true,
    "earnings_summary": true,
    "promotions": false
  },
  "language": "de",
  "theme": "system",
  "auto_accept_orders": false,
  "sound_alerts": true,
  "vibration": true
}
```

---

### 24. Update Driver Settings
**Endpoint:** `PUT /api/drivers/settings/` or `PATCH /api/drivers/settings/`

**Why it's needed:**
- Saves driver's preference changes
- Updates notification settings
- Changes language/theme
- Modifies app behavior

**Use case:**
- Called when driver saves settings
- Updates individual preferences
- Syncs to backend

**Request:**
```http
PATCH /api/drivers/settings/
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "notifications": {
    "new_orders": true,
    "promotions": false
  },
  "sound_alerts": false
}
```

**Response:**
```json
{
  "success": true,
  "settings": {
    "notifications": {
      "push_enabled": true,
      "email_enabled": false,
      "sms_enabled": false,
      "new_orders": true,
      "order_updates": true,
      "earnings_summary": true,
      "promotions": false
    },
    "language": "de",
    "theme": "system",
    "auto_accept_orders": false,
    "sound_alerts": false,
    "vibration": true
  }
}
```

---

## 📡 **REAL-TIME & LOCATION ENDPOINTS**

### 25. Update Driver Location
**Endpoint:** `POST /api/drivers/location/`

**Why it's needed:**
- Continuously updates driver GPS location
- Required for order matching and dispatching
- Shows driver location to customers
- Tracks delivery progress
- Essential for real-time tracking

**Use case:**
- Called every 10-30 seconds while online
- Background location updates
- Used during active deliveries
- Powers real-time tracking

**Request:**
```http
POST /api/drivers/location/
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "latitude": 52.5200,
  "longitude": 13.4050,
  "accuracy": 10.5,
  "heading": 270,
  "speed": 15.5,
  "timestamp": "2026-01-10T16:45:30Z"
}
```

**Request Fields:**
- `latitude` (decimal): GPS latitude
- `longitude` (decimal): GPS longitude
- `accuracy` (decimal, optional): Accuracy in meters
- `heading` (decimal, optional): Direction in degrees (0-360)
- `speed` (decimal, optional): Speed in km/h
- `timestamp` (datetime): When location was captured

**Response:**
```json
{
  "success": true,
  "location_updated": true,
  "driver_online": true
}
```

---

## 📋 **SUMMARY OF MISSING ENDPOINTS**

### **Critical (Must Have) - 9 endpoints:**
1. ✅ `GET /api/drivers/status/` - Get online/offline status
2. ✅ `GET /api/drivers/stats/today/` - Today's earnings & stats
3. ✅ `GET /api/drivers/active-order/` - Current active order
4. ✅ `GET /api/drivers/recent-orders/` - Last 5 orders
5. ✅ `GET /api/drivers/order-history/` - Full order history
6. ✅ `GET /api/drivers/stats/` - Stats by period
7. ✅ `GET /api/orders/{orderId}/` - Order details
8. ✅ `GET /api/drivers/earnings/` - Earnings by period
9. ✅ `GET /api/drivers/profile/` - Driver profile

### **Important (Should Have) - 8 endpoints:**
10. ✅ `PUT /api/drivers/profile/` - Update profile
11. ✅ `GET /api/drivers/documents/` - Get documents
12. ✅ `POST /api/drivers/documents/` - Upload document
13. ✅ `GET /api/drivers/vehicle/` - Get vehicle info
14. ✅ `PUT /api/drivers/vehicle/` - Update vehicle
15. ✅ `GET /api/notifications/` - Get notifications
16. ✅ `PUT /api/notifications/{id}/read/` - Mark as read
17. ✅ `POST /api/notifications/read-all/` - Mark all as read

### **Nice to Have - 7 endpoints:**
18. ✅ `DELETE /api/notifications/{id}/` - Delete notification
19. ✅ `GET /api/drivers/payslips/` - Get payslips
20. ✅ `GET /api/drivers/payslips/{id}/download/` - Download payslip
21. ✅ `GET /api/drivers/settings/` - Get settings
22. ✅ `PUT /api/drivers/settings/` - Update settings
23. ✅ `GET /api/orders/{id}/navigation/` - Navigation data
24. ✅ `GET /api/orders/{id}/customer-contact/` - Customer phone
25. ✅ `POST /api/drivers/location/` - Update location (if not using WebSocket)

### **WebSocket/Push Notifications (Recommended):**
- Real-time order notifications
- Order status updates
- Live location tracking
- Customer messages

---

## 🔄 **IMPLEMENTATION PRIORITY**

### **Phase 1 - Core Functionality (Week 1):**
- Get driver status
- Get/update online status (already have)
- Get active order
- Get today's stats
- Accept/reject orders (already have)
- Update order status (already have)

### **Phase 2 - Order Management (Week 2):**
- Get order details
- Get order history
- Get recent orders
- Get stats by period

### **Phase 3 - Earnings & Profile (Week 3):**
- Get earnings by period
- Get driver profile
- Update profile
- Get/update vehicle info

### **Phase 4 - Documents & Notifications (Week 4):**
- Get/upload documents
- Get notifications
- Mark notifications as read
- Get/update settings

### **Phase 5 - Advanced Features (Week 5):**
- Payslips
- Navigation data
- Customer contact
- Location tracking
- WebSocket integration

---

## 🎯 **NEXT STEPS**

1. Review this document with your backend team
2. Prioritize endpoints based on app development timeline
3. Create API implementation tickets
4. Set up proper authentication for all endpoints
5. Implement rate limiting for location updates
6. Set up WebSocket for real-time features
7. Test each endpoint with the mobile app
8. Document API changes in Swagger/OpenAPI

---

**Total Missing Endpoints: 24**
- Critical: 9
- Important: 8
- Nice to have: 7

This documentation should help your backend team understand exactly what's needed and why! 🚀
