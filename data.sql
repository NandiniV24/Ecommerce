-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: ecomdb
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin_details`
--

DROP TABLE IF EXISTS `admin_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_details` (
  `admin_username` varchar(30) NOT NULL,
  `admin_email` varchar(50) NOT NULL,
  `admin_password` varbinary(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `address` text,
  PRIMARY KEY (`admin_email`),
  UNIQUE KEY `admin_email` (`admin_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_details`
--

LOCK TABLES `admin_details` WRITE;
/*!40000 ALTER TABLE `admin_details` DISABLE KEYS */;
INSERT INTO `admin_details` VALUES ('Nandu','nandinivaddipalli24@gmail.com',_binary '$2b$12$MEoWf2aRLwwmPXk2CY8VC.to51gsu1RbU./.1cWIBXzHaqVUfTbnq','2025-06-30 11:37:48','Vijayawada');
/*!40000 ALTER TABLE `admin_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact`
--

DROP TABLE IF EXISTS `contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact` (
  `userid` int unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `useremail` varchar(50) NOT NULL,
  `complaint` varchar(255) NOT NULL,
  `complaint_status` enum('Pending','Resolved') DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact`
--

LOCK TABLES `contact` WRITE;
/*!40000 ALTER TABLE `contact` DISABLE KEYS */;
INSERT INTO `contact` VALUES (1,'Nandini','nandinivaddipalli@gmail.com','Website is not working properly','Pending','2025-06-30 15:12:11'),(2,'Nandini','nandinivaddipalli@gmail.com','Website is not working properly','Pending','2025-06-30 15:12:33');
/*!40000 ALTER TABLE `contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `itemid` binary(16) NOT NULL,
  `item_name` mediumtext NOT NULL,
  `description` longtext NOT NULL,
  `item_cost` decimal(20,4) NOT NULL,
  `item_quantity` int unsigned DEFAULT NULL,
  `item_category` enum('Home appliances','Electronics','Sports','Fashion','Grocery') DEFAULT NULL,
  `added_by` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `imgname` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`itemid`),
  KEY `items_addedby` (`added_by`),
  CONSTRAINT `items_addedby` FOREIGN KEY (`added_by`) REFERENCES `admin_details` (`admin_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES (_binary '!_öU~\Ö∞ÑG	\"ï','Havells Instanio Prime 25 Litre Storage Water Heater (Geyser) | Temp. Sensing Color Changing LED Indicator | Glass Coated Anti Rust Tank | Warranty: 5 Year on Tank | High Rise Compatible (White Blue)','About this item\r\nColour-changing LEDs that change from blue to amber to indicate the hotness of the water\r\nIt is made of ultra-thick super cold rolled steel plates that provides higher resistance to corrosion resulting in longer life than standard inner tank designs\r\nHeavy Duty Heating Element for high performance & Quick heating\r\nSuitable for high-rise buildings and pressure pump applications. The multi-function valve prevents pressure to increase beyond 8 bars\r\nIt avoids direct contact between cold and hot water flow for faster heating and optimized energy saving resulting in 20 % more hot water output',7999.0000,500,'Home appliances','nandinivaddipalli24@gmail.com','2025-06-30 12:17:46','To8Ac1.jpg'),(_binary '=Qh8Uy\Ö∞ÑG	\"ï','Lumio Vision 7 139 cm (55 inches) 4K Ultra-HD Smart QLED Google TV FTW3-ADSG','About this item\r\n1)Performance : India\'s Fastest Smart TV* | BOSS Processor | 3GB DDR4 RAM | 16GB ROM | 2X Faster Boot time | 2.8X Faster Netflix load time | 2.1X Faster WiFi throughput\r\n2)Display: QLED | DOPE Display | 4K Ultra HD (3840 x 2160) | 66 Blue LEDs for Wide Color Gamut (108% DCI-P3)(79% Rec.2020) | Refresh 3)Rate : 60 Hertz | 400 Nits (peak) | High Color Accuracy with ŒîE ~ 1.44 | 4K HDR | Dolby Vision | HDR10 | HLG | MEMC | ALLM | 4K AI Upscaling\r\n4)Sound: DGS Sound | 30 Watts Output | Quad Driver Speakers (2 Tweeter + 2 Full Range) | Dolby Audio | Dolby Atmos | Large Speaker Cavity (960 mL) for Crystal Clear Sound\r\n5)Connectivity: WiFi 2.4GHz/5GHz 802.11a/b/g/n/ac | Bluetooth 5 | HDMI 2.1 x 3 (1 with eARC) | HDMI Bandwidth 48Gbps | 1 AV Input Mini | 1 Digital Audio Output Optical | 3.5mm Audio Output Supports upto 300Œ© load | USB 3.0 x1, USB 2.0 x2 | Ethernet RJ45 x1 (100Mbps)\r\n6)Warranty Information: 2 year comprehensive warranty provided by the brand from the date of purchase',39999.0000,600,'Home appliances','nandinivaddipalli24@gmail.com','2025-06-30 11:42:45','Dt3Ro8.jpg'),(_binary '=Sr\“Uz\Ö∞ÑG	\"ï','Daawat Super Basmati Rice 1Kg | Fluffy Long Grains| Cooked upto 20mm*','Elevate your dishes with the superior quality and aromatic essence, ideal for an array of exotic dishes, adding a touch of sophistication and flavor to every meal. Whether it\'s the vibrant flavors of fried rice, the creamy richness of risotto, the comforting essence of Rajma rice, or any other gourmet creation, this Basmati rice lends itself seamlessly to diverse culinary creations.',180.0000,800,'Grocery','nandinivaddipalli24@gmail.com','2025-06-30 11:49:55','Fb1Nq6.jpg'),(_binary '^:IzUz\Ö∞ÑG	\"ï','Mysore Sandal Soap,450g (150x3) (Pack Of 3)','About this item\r\nProven for long term skin benefits\r\nDecreases the chances of skin ailments, including skin cancer\r\nApart from cleaning action, excellent moisturizing, nourishing, with enthralling aroma of natural sandalwood oil based fragrance\r\nFeatures: Decreases the chances of skin ailments, Proven for long term skin benefits\r\nTarget Audience: Men & Women\r\nPackage Content: 450g (150x3) Pack of 3 Soaps',209.0000,900,'Grocery','nandinivaddipalli24@gmail.com','2025-06-30 11:50:50','Xz3Am0.jpg'),(_binary 'lôÿ¨Uy\Ö∞ÑG	\"ï','LG 1.5 Ton 5 Star DUAL Inverter Split AC (Copper, AI Convertible 6-in-1, VIRAAT Mode, Faster Cooling & Energy Saving, 4 Way Swing, HD Filter with Anti-Virus Protection, US-Q19YNZE, White)','About this item\r\nLG Split AC with Dual inverter compressor: Experience powerful cooling with LG Split AC, featuring an energy-efficient inverter compressor for optimal performance and long-lasting durability.\r\nCapacity: 1.5 Ton - Suitable for medium sized rooms (111 to 150 sq.ft); Air Circulation: 653/1236 (In/Out) CFM, Cooling Capacity 5000 W & Ambient Temperature: 55 degree Celsius with 4 way air swing\r\nEnergy Rating: 5 Star - Best in class efficiency | Annual Energy Consumption: 744.75 units. ISEER Value: 5.20 (Please Refer Energy Label on Product Page or Contact Brand for More Details)\r\nManufacturer Warranty: 1 Year Comprehensive on Product, 5 Year on PCB and Motor & 10 Year on Compressor (*Free Gas charging during comprehensive period only | T&C Apply)\r\nCopper Condenser Coil:100% Copper Tubes with Ocean Black Protection: Increases Durability; Uninterrupted Cooling; Prevents Rust & Corrosion\r\nKey Features: Dual Inverter Compressor, AI Convertible 6-in-1, VIRAAT Mode, HD Filter with Anti-Virus Protection, ADC Sensor, Cools at 55‚Å∞ C, Stabilizer free operation within 120V-290V voltage range , Temperature Display type ‚Äì Magic Display (LED) for temperature and timer modes, Noise Level: IDU - 31 (db) & ODU ‚Äì 56 (db), 15 MTS Airthrow\r\nSpecial Features: Gold Fin+ - Increase durability, Ocean black protection, Ez Clean Filter, Low gas detection, 100% Copper Condensor, 6 Fan Speed steps; Hi grooved Copper; Smart Diagnosis System, Comfort Air, Monsoon Comfort/Fresh Dry, Auto Clean, Mute Function, On/ Off Timer, Sleep Mode, Auto Restart (Memory), On/Off Indicator, Dehumidifier; Diet Mode Plus; Fan Speed Steps: 6',45490.0000,600,'Home appliances','nandinivaddipalli24@gmail.com','2025-06-30 11:44:04','Ea5Yy9.webp'),(_binary 't\r-†U~\Ö∞ÑG	\"ï','LIRAMARK Mobile Phone Charging Stand, Storage Holder, Bedside Fixed Rack, Home Organization and Storage Supplies, Bedroom Accessories, Office Accessories, Bathroom Accessories','About this item\r\nWall Phone Holder: Universal mobile phone holder for most of smart phone models, offering a safer charging stand for your phones. Note: The total thickness of devices should be less than 30mm.\r\nSmartphone wall holder can give your phone a safe dock while charging With wide range of application this wall mount for phone can be used on smooth and even wallpaper lime wall tile stainless steel glass wooden and metal surface.\r\nMobile Wall Mount for charging AC/TV Storage Box Remote Storage Organizer Case for All Smartphones, Samsung,iPhone,Redmi,Vivo,Oppo,Honnor,Sony Phone Charger\r\nComes with High power Self Adhesive on the back for easy installation.\r\nEasy Mount - This Wall Mount Holder can easily be attached to a wall with Smooth Surface, such as Lime wall, Glass wall, Ceramic wall or a wall with Wallpaper',100.0000,970,'Electronics','nandinivaddipalli24@gmail.com','2025-06-30 12:20:04','Dc4Od6.webp'),(_binary 'Ö\€\ŒSUz\Ö∞ÑG	\"ï','FEROC 2 Pieces Aluminium Badminton Racket with 3 Pieces Feather Shuttles with Full-Cover Set,Aluminum, Multicolor (Multicolor)','\r\nSize	One Size\r\nBrand	FEROC\r\nGrip Size	3 1/4 inches\r\nSport	Badminton\r\nMaterial	Aluminium',500.0000,580,'Sports','nandinivaddipalli24@gmail.com','2025-06-30 11:51:56','Rb0Af1.jpg'),(_binary 'éó\ƒ\ŸUy\Ö∞ÑG	\"ï','BIBA Women\'s Fit and Flare Ankle Length Cotton Flared Printed Dress','About this item\r\nProduct Type:- Dress\r\nColor :-Teal\r\nFabric:- Cotton\r\nSleeve :-3/4th Sleeves\r\nNeck Type :-Collar Neck',1649.0000,800,'Fashion','nandinivaddipalli24@gmail.com','2025-06-30 11:45:02','Xc1Td0.jpg'),(_binary 'ï¯§ÜU~\Ö∞ÑG	\"ï','Boult Audio Z40 True Wireless in Ear Earbuds with 60H Playtime, Zen‚Ñ¢ ENC Mic, Low Latency Gaming, Type-C Fast Charging, Made in India, 10mm Rich Bass Drivers, IPX5, Bluetooth 5.3 Ear Buds TWS (White)','About this item\r\n‚úÖ 60-Hour Playtime: The Boult Z40 earbuds offer an impressive 60 hours of continuous playtime on a single charge, ensuring you can enjoy your music, podcasts, or calls for days without needing a recharge. Perfect for long journeys, workdays, or extended use.\r\n‚úÖ Zen ENC Mic for Clear Calls: Communicate with ease using the advanced Zen Environmental Noise Cancellation (ENC) mic. This technology reduces background noise, providing clear and crisp voice quality for calls and voice commands.\r\n‚úÖ Low Latency Gaming Mode: The Z40 earbuds feature a low latency mode, designed to minimize audio delay, enhancing your gaming experience with perfectly synchronized sound. Enjoy an immersive and competitive edge in your favorite games.\r\n‚úÖ Powerful 10mm Drivers: Experience deep, rich bass with the Z40‚Äôs 10mm drivers. Whether you enjoy bass-heavy tracks or dynamic soundscapes, these earbuds deliver a powerful and immersive audio experience.\r\n‚úÖ Type-C Fast Charging: Enjoy quick and efficient power-ups with Type-C fast charging. A brief charge provides hours of playback, making these earbuds ideal for those constantly on the move.\r\n‚úÖ Ergonomic and Comfortable Fit: Designed for long-term wear, the Z40 earbuds feature an ergonomic fit that stays secure during various activities, ensuring comfort even during extended listening sessions.\r\n‚úÖ Touch Controls: Manage your music, calls, and voice assistants effortlessly with intuitive touch controls. Easily adjust volume, skip tracks, or take calls with simple taps for a seamless experience.',999.0000,490,'Electronics','nandinivaddipalli24@gmail.com','2025-06-30 12:21:01','Ky4Nf8.jpg'),(_binary '¨Å¡æUz\Ö∞ÑG	\"ï','BRUTON Exclusive Trendy Sports Running Shoes | Casual Shoe | Sneakers for Men\'s & Boy\'s','About this item\r\n‚úî RUNNING SHOES: The BRUTON Men\'s Running Shoes are designed to provide your feet with the support and comfort they require throughout your workout.\r\n‚úî PERFORMANCE! : Our Footwear Are Made With Good Material And Offers You a Trendy Design With Long Lasting Performance.\r\n‚úîPVC OUTSOLE: The PVC outsole enhances shock absorbency and slip resistance, and overall gives you the perfect experience. This is made from pure grade PVC material for a lightweight sole with the function of shock absorbing and cushioning, while the textured outsole provides complete durability.\r\n‚úîLIFESTYLE: Sports, Running, Walking, Gym, Casual, Sneakers, Party wear, Yoga Shoes, Hiking & Travelling\r\n‚úîSUITABLE FOR: Men, Boys & Girls',299.0000,600,'Sports','nandinivaddipalli24@gmail.com','2025-06-30 11:53:01','Ma3Gp1.jpg'),(_binary '∂vÆ\ÔUy\Ö∞ÑG	\"ï','iconics Women ComfortableBlock Heel Round Toe Strapless Fashion Shoes for Daily use, Office use, Casual use','About this item\r\nCOMFORTABLE MATERIAL: Iconics Women‚Äôs Sandals are lightweight, durable and have a padded insole, slip-resistant rubber outsole, with soft anti-sweat lining.\r\nCONVENIENT SLIP-ON STYLE: Allowing for quick and easy wearing without the hassle of fastening buckles or laces. This makes them a convenient option for those on-the-go or in a hurry, while still looking stylish.\r\nIDEAL FOR ANY PLACE/ OCCASION: Comfortable Flats are suitable for any seasons, go well with all outfits. Perfect for daily walking, working, casual, dress, shopping, travel, long time standing, driving, running, etc.\r\nVersatile addition to your wardrobe that works year-round\r\nDisclaimer : Product color may slightly vary due to photographic lighting sources or your monitor settings',749.0000,500,'Fashion','nandinivaddipalli24@gmail.com','2025-06-30 11:46:08','Vm9Vf9.jpg'),(_binary '¡@‘¨U~\Ö∞ÑG	\"ï','TIMEX iConnect Calling Max 2.01\"(5.1cm) Display with Functional Crown and BT Calling Smartwatch for Unisex - TWIXW1302T','About this item\r\nDisplay: 2.01\" TFT display with a resolution 240x296 pixels.\r\nBluetooth Calling: Enjoy the advanced Bluetooth chip for a HD calling experience.\r\nFunctional Crown: Effortlessly access a range of features with the functional crown.\r\nAI Voice Assistant: Seamlessly integrates with Google Assistant or Siri, enabling users to interact with their phones using the smartwatch.\r\nApplication : Use Timex Fit 2.0 app to sync your smart watch with your phone.',1399.0000,500,'Fashion','nandinivaddipalli24@gmail.com','2025-06-30 12:22:14','Jj8Nm5.jpg'),(_binary '\‡\€\ˆ\‘Uy\Ö∞ÑG	\"ï','Redmi Note 14 5G (Titan Black, 8GB RAM 256GB Storage) | Global Debut MTK Dimensity 7025 Ultra | 2100 nits Segment Brightest 120Hz AMOLED | 50MP Sony LYT 600 OIS+EIS Triple Camera','\r\nBrand	Redmi\r\nRAM Memory Installed Size	8 GB\r\nCPU Model	Others\r\nCPU Speed	2.5E+3 MHz\r\nResolution	1080 x 2400',19999.0000,790,'Electronics','nandinivaddipalli24@gmail.com','2025-06-30 11:47:20','Ie2Nv5.webp'),(_binary '¯éù\ÀX\»\Ö∞ÑG	\"ï','EPOS Impact 760 Office Headset: Premium Dual-Sided, Noise-Cancelling USB-C Headset with Adaptive Beamforming Mic, AI, ActiveGard Protection, Busylight, Leatherette Earpads for All-Day Comfort','About this item\r\nPREMIUM AUDIO QUALITY ‚Äì Experience unmatched clarity with EPOS AI-driven adaptive beamforming microphone system, ensuring crystal-clear calls even in noisy environments\r\nALL-DAY COMFORT ‚Äì Ultra-lightweight design with plush leatherette earpads, providing unparalleled comfort for prolonged usage in any office setting\r\nADVANCED NOISE CANCELLATION ‚Äì Stay focused with superior passive noise dampening and ActiveGard technology, safeguarding against acoustic shock and sudden sound bursts\r\nSEAMLESS CONNECTIVITY ‚Äì Effortlessly connect to any device with USB-C and USB-A options; comes with inline controller for easy call management\r\nINTELLIGENT FEATURES ‚Äì Smart busylight indicator minimizes interruptions, while intuitive controls allow for quick muting/unmuting and volume adjustments',13000.0000,1000,'Electronics','nandinivaddipalli24@gmail.com','2025-07-04 16:51:03','Hs8Dj4.jpg');
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `item_id` binary(16) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `payment_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `payment_by` (`payment_by`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`payment_by`) REFERENCES `users` (`useremail`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `items` (`itemid`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (4,'2025-06-30 11:58:08',_binary '=Qh8Uy\Ö∞ÑG	\"ï','Lumio Vision 7 139 cm (55 inches) 4K Ultra-HD Smart QLED Google TV FTW3-ADSG',3999900.00,'vaddipallinandini23@gmail.com'),(5,'2025-06-30 12:04:50',_binary '^:IzUz\Ö∞ÑG	\"ï','Mysore Sandal Soap,450g (150x3) (Pack Of 3)',20900.00,'vaddipallinandini23@gmail.com'),(6,'2025-06-30 12:26:59',_binary '!_öU~\Ö∞ÑG	\"ï','Havells Instanio Prime 25 Litre Storage Water Heater (Geyser) | Temp. Sensing Color Changing LED Indicator | Glass Coated Anti Rust Tank | Warranty: 5 Year on Tank | High Rise Compatible (White Blue)',799900.00,'vaddipallinandini23@gmail.com');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` int unsigned NOT NULL AUTO_INCREMENT,
  `review_text` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `itemid` binary(16) DEFAULT NULL,
  `added_by` varchar(40) DEFAULT NULL,
  `rating` enum('1','2','3','4','5') DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  KEY `itemid` (`itemid`),
  KEY `added_by` (`added_by`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`itemid`) REFERENCES `items` (`itemid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`added_by`) REFERENCES `users` (`useremail`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (5,'TV was very good and has great picture quality','2025-06-30 11:58:57',_binary '=Qh8Uy\Ö∞ÑG	\"ï','vaddipallinandini23@gmail.com','4'),(6,'Excellent','2025-06-30 12:05:18',_binary '^:IzUz\Ö∞ÑG	\"ï','vaddipallinandini23@gmail.com','5'),(7,'Great product','2025-06-30 12:27:40',_binary '!_öU~\Ö∞ÑG	\"ï','vaddipallinandini23@gmail.com','4');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `useremail` varchar(30) NOT NULL,
  `username` varchar(30) NOT NULL,
  `password` varbinary(255) NOT NULL,
  `address` text NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `gender` enum('Male','Female','Other') NOT NULL,
  PRIMARY KEY (`useremail`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('vaddipallinandini23@gmail.com','Nandini Vaddipalli',_binary '$2b$12$vl/XrX/QWoerw3.C773dh.ixqxm0OVQdxhTSnDRLVMlyo.aS8TCyK','Vijayawada','2025-06-30 11:55:04','Female');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-05 11:50:27
