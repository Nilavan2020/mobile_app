-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 06, 2026 at 10:54 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smart_safety_welfare_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `face_sessions`
--

CREATE TABLE `face_sessions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `place_name` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `face_sessions`
--

INSERT INTO `face_sessions` (`id`, `name`, `place_name`, `notes`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'Temple 01', 'Kandy', 'Notes', 1, '2026-01-06 13:10:16', '2026-01-06 13:10:16'),
(2, 'Temple2', 'Jaffna', NULL, 1, '2026-01-06 15:41:04', '2026-01-06 15:41:04');

-- --------------------------------------------------------

--
-- Table structure for table `face_session_images`
--

CREATE TABLE `face_session_images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `face_session_id` bigint(20) UNSIGNED NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `original_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `face_session_images`
--

INSERT INTO `face_session_images` (`id`, `face_session_id`, `file_path`, `original_name`, `created_at`, `updated_at`) VALUES
(1, 1, 'face_sessions/1/db/abec5214-c7fc-4e08-b01d-e7949dbd116c.jpg', '11.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(2, 1, 'face_sessions/1/db/59d2b5f4-a242-421d-ad64-886f0fa6d474.jpg', 'v-1.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(3, 1, 'face_sessions/1/db/9fb8b7c2-431d-4608-909b-ee2c1c935b5c.jpg', 'v-2.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(4, 1, 'face_sessions/1/db/229d2aa2-ad44-42a2-9e6c-fe177ec674e3.jpg', 'v-3.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(5, 1, 'face_sessions/1/db/831c2eb8-07e1-4f35-9a4e-1006a0b30d6a.jpg', 'v-4.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(6, 1, 'face_sessions/1/db/070acf7f-af9e-4a73-ad27-91dbab700c90.jpg', 'v-5.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(7, 1, 'face_sessions/1/db/478760d9-d237-4086-91cb-9e07744a1d5b.jpg', 'v-6.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(8, 1, 'face_sessions/1/db/b5801180-50f6-4a4d-b22c-0fbde501a976.jpg', 'v-7.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(9, 1, 'face_sessions/1/db/963997b8-983d-42ad-b3f9-0883903287c7.jpg', 'v-8.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(10, 1, 'face_sessions/1/db/b543561e-97aa-4e29-a4e6-9f92e5986fb7.jpg', 'v-9.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(11, 1, 'face_sessions/1/db/f5c18c3f-68f5-47e4-a6b9-61809fdf5c4e.jpg', 'v-10.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(12, 1, 'face_sessions/1/db/13fd56cf-8bcc-456a-8bfb-c9cb8ddb7ee9.jpg', 'v-12.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(13, 1, 'face_sessions/1/db/44a20dc7-7a2b-4834-ab3a-62967a2332ba.jpg', 'v-13.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(14, 1, 'face_sessions/1/db/68038120-65ef-4616-acbb-7be9ee83a7da.jpg', 'v-14.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(15, 1, 'face_sessions/1/db/e33b3b84-e633-4083-b88e-7002ed1f02b1.jpg', 'v-15.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(16, 1, 'face_sessions/1/db/d1f20c56-43b3-4b4d-8616-bb506d89b579.jpg', 'v-16.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(17, 1, 'face_sessions/1/db/86982e2e-e4e5-451a-a3f2-451291638d9f.jpg', 'v-17.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(18, 1, 'face_sessions/1/db/af4fba4d-625f-4db0-ba62-caa66f4491f9.jpg', 'v-18.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(19, 1, 'face_sessions/1/db/9c29d5a9-5ea9-4dfc-b3f4-58d725159efb.jpg', 'v-19.jpg', '2026-01-06 13:17:32', '2026-01-06 13:17:32'),
(20, 1, 'face_sessions/1/db/150bb0bb-8cf3-472c-aed4-073dffd64533.jpg', 'v-20.jpg', '2026-01-06 13:17:33', '2026-01-06 13:17:33'),
(21, 2, 'face_sessions/2/db/29704ad3-9852-49a9-84e1-0d3bd57746e9.jpg', 'v-6.jpg', '2026-01-06 15:41:15', '2026-01-06 15:41:15'),
(22, 2, 'face_sessions/2/db/1e52c960-a58b-49d7-9f10-e90b61daec5f.jpg', 'v-9.jpg', '2026-01-06 15:41:15', '2026-01-06 15:41:15'),
(23, 2, 'face_sessions/2/db/ef16d6a7-237c-4b4d-89d5-e7b6da6b9b72.jpg', 'v-1.jpg', '2026-01-06 15:53:16', '2026-01-06 15:53:16'),
(24, 2, 'face_sessions/2/db/43b73021-f2c7-4fa1-8595-3a1d4dd970c8.jpg', 'v-2.jpg', '2026-01-06 15:53:16', '2026-01-06 15:53:16'),
(25, 2, 'face_sessions/2/db/5382ef7a-713e-4d79-bcf5-2731d5d0212e.jpg', 'v-3.jpg', '2026-01-06 15:53:16', '2026-01-06 15:53:16');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2024_10_23_162400_create_mobile_users_table', 1),
(5, '2024_12_21_100000_create_relief_requests_table', 2),
(6, '2024_12_21_100001_create_relief_donations_table', 2),
(7, '2025_01_06_000001_add_emergency_contacts_to_mobile_users_table', 3),
(8, '2025_01_15_000001_create_sos_alerts_table', 4),
(9, '2026_01_06_162451_add_status_to_sos_alerts_table', 5),
(10, '2026_01_06_200000_create_face_sessions_table', 6),
(11, '2026_01_06_200001_create_face_session_images_table', 6);

-- --------------------------------------------------------

--
-- Table structure for table `mobile_users`
--

CREATE TABLE `mobile_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `emergency_contact` varchar(255) DEFAULT NULL,
  `police_contact` varchar(255) DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `dob` date NOT NULL,
  `status` enum('pending','approved') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mobile_users`
--

INSERT INTO `mobile_users` (`id`, `full_name`, `email`, `password`, `phone_number`, `emergency_contact`, `police_contact`, `gender`, `dob`, `status`, `created_at`, `updated_at`) VALUES
(1, 'gunarakulan', 'guna@gmail.com', 'guna@123', '1234546576', NULL, NULL, 'male', '1997-10-12', 'approved', '2026-01-06 06:46:44', '2026-01-06 06:46:44'),
(2, 'test', 'test@gmail.com', 'test@123', '1234567', NULL, NULL, 'male', '1999-11-11', 'pending', '2026-01-06 08:00:15', '2026-01-06 08:00:15'),
(3, 'GTA', 'gta@gmail.com', 'gta123456', '234537668', '94 740001141', '94 740001141', 'female', '1997-11-11', 'approved', '2026-01-06 08:03:09', '2026-01-06 10:09:33');

-- --------------------------------------------------------

--
-- Table structure for table `relief_donations`
--

CREATE TABLE `relief_donations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `item_type` varchar(255) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `district` varchar(255) NOT NULL,
  `status` enum('pending','delivered','cancelled') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `relief_donations`
--

INSERT INTO `relief_donations` (`id`, `user_id`, `item_type`, `item_name`, `quantity`, `description`, `district`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 'medicine', 'Panadol', 100, 'Donating for request #5', 'Puttalam', 'pending', '2026-01-06 07:24:43', '2026-01-06 07:24:43'),
(2, 1, 'medicine', 'Panadol', 100, 'Donating for request #5', 'Puttalam', 'delivered', '2026-01-06 07:24:44', '2026-01-06 07:25:48'),
(3, 3, 'funding', 'Relief Fund', 21, 'Donating for request #256', 'Jaffna', 'delivered', '2026-01-06 16:09:58', '2026-01-06 16:10:21');

-- --------------------------------------------------------

--
-- Table structure for table `relief_requests`
--

CREATE TABLE `relief_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `item_type` varchar(255) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `district` varchar(255) NOT NULL,
  `status` enum('pending','fulfilled','cancelled') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `relief_requests`
--

INSERT INTO `relief_requests` (`id`, `user_id`, `item_type`, `item_name`, `quantity`, `description`, `district`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 'food', 'Rice', 5, NULL, 'Hambantota', 'fulfilled', '2026-01-06 07:14:59', '2026-01-06 07:19:37'),
(2, 1, 'water', 'Water Bottle', 100, NULL, 'Batticaloa', 'fulfilled', '2026-01-06 07:19:02', '2026-01-06 07:19:44'),
(3, 1, 'food', 'Soda', 100, NULL, 'Puttalam', 'fulfilled', '2026-01-06 07:23:12', '2026-01-06 07:26:57'),
(4, 1, 'food', 'Soda', 100, NULL, 'Puttalam', 'pending', '2026-01-06 07:23:12', '2026-01-06 07:23:12'),
(5, 1, 'medicine', 'Panadol', 100, NULL, 'Puttalam', 'fulfilled', '2026-01-06 07:23:47', '2026-01-06 07:26:53'),
(6, 1, 'medicine', 'Pain Relievers', 74, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(7, 1, 'funding', 'Emergency Fund', 19, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(8, 1, 'funding', 'Relief Fund', 15, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(9, 1, 'water', 'Bottled Water', 67, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(10, 1, 'food', 'Sugar', 31, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(11, 1, 'funding', 'Relief Fund', 36, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(12, 1, 'medicine', 'Antibiotics', 65, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(13, 1, 'medicine', 'Pain Relievers', 49, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(14, 1, 'medicine', 'First Aid Kit', 24, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(15, 1, 'food', 'Canned Food', 23, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(16, 1, 'water', 'Water Containers', 32, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(17, 1, 'food', 'Canned Food', 83, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(18, 1, 'medicine', 'Antibiotics', 77, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(19, 1, 'water', 'Bottled Water', 54, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(20, 1, 'food', 'Canned Food', 11, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(21, 1, 'medicine', 'Antibiotics', 51, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(22, 1, 'funding', 'Relief Fund', 63, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(23, 1, 'funding', 'Emergency Fund', 88, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(24, 1, 'water', 'Bottled Water', 50, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(25, 1, 'medicine', 'Pain Relievers', 96, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(26, 1, 'food', 'Rice', 62, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(27, 1, 'water', 'Bottled Water', 98, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(28, 1, 'funding', 'Emergency Fund', 62, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(29, 1, 'funding', 'Emergency Fund', 91, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(30, 1, 'funding', 'Relief Fund', 17, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(31, 1, 'water', 'Bottled Water', 21, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(32, 1, 'funding', 'Emergency Fund', 70, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(33, 1, 'funding', 'Emergency Fund', 54, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(34, 1, 'food', 'Sugar', 56, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(35, 1, 'food', 'Flour', 68, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(36, 1, 'water', 'Water Containers', 79, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(37, 1, 'funding', 'Emergency Fund', 94, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(38, 1, 'food', 'Canned Food', 64, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(39, 1, 'food', 'Canned Food', 20, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(40, 1, 'funding', 'Relief Fund', 52, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(41, 1, 'medicine', 'First Aid Kit', 54, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(42, 1, 'medicine', 'Pain Relievers', 88, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(43, 1, 'water', 'Bottled Water', 85, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:45:55', '2026-01-06 07:45:55'),
(44, 1, 'funding', 'Relief Fund', 24, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(45, 1, 'medicine', 'Antibiotics', 31, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(46, 1, 'water', 'Water Containers', 89, 'Test request for Matale district', 'Matale', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(47, 1, 'food', 'Flour', 23, 'Test request for Matale district', 'Matale', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(48, 1, 'funding', 'Relief Fund', 90, 'Test request for Matale district', 'Matale', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(49, 1, 'water', 'Bottled Water', 76, 'Test request for Galle district', 'Galle', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(50, 1, 'funding', 'Relief Fund', 69, 'Test request for Galle district', 'Galle', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(51, 1, 'water', 'Water Containers', 73, 'Test request for Matara district', 'Matara', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(52, 1, 'water', 'Bottled Water', 62, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(53, 1, 'water', 'Water Containers', 100, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(54, 1, 'water', 'Water Containers', 92, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(55, 1, 'funding', 'Relief Fund', 34, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(56, 1, 'food', 'Flour', 19, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(57, 1, 'medicine', 'Pain Relievers', 61, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(58, 1, 'medicine', 'First Aid Kit', 64, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(59, 1, 'food', 'Flour', 17, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(60, 1, 'water', 'Bottled Water', 63, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(61, 1, 'funding', 'Emergency Fund', 17, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(62, 1, 'funding', 'Emergency Fund', 34, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(63, 1, 'medicine', 'Antibiotics', 53, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(64, 1, 'water', 'Bottled Water', 90, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(65, 1, 'medicine', 'Antibiotics', 59, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(66, 1, 'water', 'Bottled Water', 15, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(67, 1, 'water', 'Bottled Water', 27, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(68, 1, 'medicine', 'Antibiotics', 91, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(69, 1, 'water', 'Water Containers', 97, 'Test request for Batticaloa district', 'Batticaloa', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(70, 1, 'food', 'Sugar', 40, 'Test request for Batticaloa district', 'Batticaloa', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(71, 1, 'medicine', 'Pain Relievers', 46, 'Test request for Batticaloa district', 'Batticaloa', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(72, 1, 'funding', 'Emergency Fund', 77, 'Test request for Batticaloa district', 'Batticaloa', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(73, 1, 'food', 'Rice', 94, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(74, 1, 'food', 'Flour', 18, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(75, 1, 'food', 'Sugar', 97, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(76, 1, 'water', 'Water Containers', 12, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(77, 1, 'food', 'Rice', 43, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(78, 1, 'funding', 'Relief Fund', 98, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(79, 1, 'funding', 'Emergency Fund', 18, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(80, 1, 'food', 'Rice', 43, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(81, 1, 'funding', 'Relief Fund', 60, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(82, 1, 'water', 'Water Containers', 29, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(83, 1, 'medicine', 'Antibiotics', 14, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(84, 1, 'water', 'Water Containers', 26, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(85, 1, 'food', 'Sugar', 20, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(86, 1, 'food', 'Sugar', 12, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(87, 1, 'water', 'Water Containers', 25, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(88, 1, 'funding', 'Relief Fund', 55, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(89, 1, 'funding', 'Emergency Fund', 11, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(90, 1, 'water', 'Bottled Water', 66, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(91, 1, 'medicine', 'Pain Relievers', 36, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(92, 1, 'water', 'Bottled Water', 35, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(93, 1, 'food', 'Canned Food', 86, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(94, 1, 'water', 'Water Containers', 73, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(95, 1, 'food', 'Rice', 22, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(96, 1, 'food', 'Rice', 20, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(97, 1, 'food', 'Sugar', 100, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(98, 1, 'medicine', 'First Aid Kit', 97, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(99, 1, 'medicine', 'Pain Relievers', 81, 'Test request for Badulla district', 'Badulla', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(100, 1, 'medicine', 'First Aid Kit', 88, 'Test request for Badulla district', 'Badulla', 'pending', '2026-01-06 07:45:56', '2026-01-06 07:45:56'),
(101, 1, 'funding', 'Relief Fund', 28, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(102, 1, 'food', 'Flour', 13, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(103, 1, 'water', 'Bottled Water', 37, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(104, 1, 'medicine', 'Pain Relievers', 32, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(105, 1, 'water', 'Bottled Water', 47, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(106, 1, 'water', 'Water Containers', 94, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(107, 1, 'food', 'Rice', 57, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(108, 1, 'water', 'Bottled Water', 66, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(109, 1, 'food', 'Flour', 71, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(110, 1, 'food', 'Rice', 25, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(111, 1, 'medicine', 'Pain Relievers', 70, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(112, 1, 'water', 'Water Containers', 37, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(113, 1, 'water', 'Bottled Water', 90, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(114, 1, 'water', 'Water Containers', 97, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(115, 1, 'water', 'Water Containers', 62, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(116, 1, 'funding', 'Relief Fund', 97, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(117, 1, 'medicine', 'Pain Relievers', 28, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(118, 1, 'food', 'Canned Food', 37, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(119, 1, 'water', 'Bottled Water', 80, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(120, 1, 'food', 'Flour', 31, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(121, 1, 'food', 'Canned Food', 33, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(122, 1, 'water', 'Water Containers', 37, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(123, 1, 'food', 'Rice', 25, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(124, 1, 'funding', 'Emergency Fund', 97, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(125, 1, 'medicine', 'Pain Relievers', 67, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(126, 1, 'medicine', 'Pain Relievers', 35, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(127, 1, 'water', 'Bottled Water', 26, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(128, 1, 'food', 'Sugar', 72, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(129, 1, 'water', 'Water Containers', 17, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(130, 1, 'funding', 'Emergency Fund', 30, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(131, 1, 'medicine', 'Pain Relievers', 84, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(132, 1, 'funding', 'Relief Fund', 58, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(133, 1, 'funding', 'Relief Fund', 40, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(134, 1, 'medicine', 'First Aid Kit', 19, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(135, 1, 'food', 'Flour', 83, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(136, 1, 'food', 'Rice', 89, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(137, 1, 'funding', 'Emergency Fund', 99, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(138, 1, 'medicine', 'First Aid Kit', 43, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(139, 1, 'medicine', 'Antibiotics', 97, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(140, 1, 'funding', 'Emergency Fund', 63, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(141, 1, 'food', 'Canned Food', 31, 'Test request for Matale district', 'Matale', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(142, 1, 'water', 'Bottled Water', 16, 'Test request for Matale district', 'Matale', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(143, 1, 'medicine', 'Antibiotics', 35, 'Test request for Matale district', 'Matale', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(144, 1, 'funding', 'Relief Fund', 26, 'Test request for Galle district', 'Galle', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(145, 1, 'water', 'Water Containers', 33, 'Test request for Galle district', 'Galle', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(146, 1, 'funding', 'Relief Fund', 34, 'Test request for Matara district', 'Matara', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(147, 1, 'food', 'Rice', 15, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(148, 1, 'water', 'Water Containers', 71, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(149, 1, 'food', 'Rice', 38, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(150, 1, 'water', 'Water Containers', 36, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(151, 1, 'water', 'Bottled Water', 30, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(152, 1, 'water', 'Bottled Water', 22, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(153, 1, 'water', 'Bottled Water', 65, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(154, 1, 'medicine', 'Pain Relievers', 66, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(155, 1, 'medicine', 'First Aid Kit', 37, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(156, 1, 'medicine', 'First Aid Kit', 17, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(157, 1, 'water', 'Water Containers', 44, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(158, 1, 'medicine', 'Antibiotics', 97, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(159, 1, 'water', 'Water Containers', 42, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(160, 1, 'water', 'Bottled Water', 52, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(161, 1, 'medicine', 'Antibiotics', 30, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(162, 1, 'medicine', 'First Aid Kit', 13, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(163, 1, 'medicine', 'First Aid Kit', 14, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(164, 1, 'medicine', 'Pain Relievers', 65, 'Test request for Batticaloa district', 'Batticaloa', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(165, 1, 'water', 'Water Containers', 86, 'Test request for Batticaloa district', 'Batticaloa', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(166, 1, 'funding', 'Emergency Fund', 29, 'Test request for Batticaloa district', 'Batticaloa', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(167, 1, 'water', 'Bottled Water', 32, 'Test request for Batticaloa district', 'Batticaloa', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(168, 1, 'medicine', 'Antibiotics', 49, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(169, 1, 'food', 'Flour', 95, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(170, 1, 'medicine', 'Pain Relievers', 42, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(171, 1, 'funding', 'Relief Fund', 100, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(172, 1, 'water', 'Bottled Water', 18, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(173, 1, 'funding', 'Relief Fund', 88, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(174, 1, 'medicine', 'Antibiotics', 94, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(175, 1, 'water', 'Bottled Water', 36, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(176, 1, 'food', 'Flour', 26, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(177, 1, 'food', 'Sugar', 60, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(178, 1, 'funding', 'Relief Fund', 48, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(179, 1, 'water', 'Bottled Water', 75, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(180, 1, 'medicine', 'First Aid Kit', 40, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(181, 1, 'food', 'Rice', 34, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(182, 1, 'food', 'Flour', 100, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(183, 1, 'water', 'Water Containers', 10, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(184, 1, 'food', 'Flour', 84, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(185, 1, 'water', 'Bottled Water', 96, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(186, 1, 'funding', 'Relief Fund', 82, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(187, 1, 'funding', 'Relief Fund', 84, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(188, 1, 'food', 'Sugar', 90, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(189, 1, 'medicine', 'Pain Relievers', 91, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(190, 1, 'funding', 'Emergency Fund', 78, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(191, 1, 'funding', 'Emergency Fund', 72, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(192, 1, 'food', 'Flour', 75, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(193, 1, 'medicine', 'Antibiotics', 67, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(194, 1, 'water', 'Water Containers', 41, 'Test request for Badulla district', 'Badulla', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(195, 1, 'medicine', 'First Aid Kit', 39, 'Test request for Badulla district', 'Badulla', 'pending', '2026-01-06 07:46:06', '2026-01-06 07:46:06'),
(196, 1, 'food', 'Flour', 100, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(197, 1, 'medicine', 'Antibiotics', 21, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(198, 1, 'water', 'Bottled Water', 46, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(199, 1, 'food', 'Canned Food', 99, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(200, 1, 'medicine', 'Pain Relievers', 50, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(201, 1, 'medicine', 'Pain Relievers', 53, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(202, 1, 'medicine', 'First Aid Kit', 96, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(203, 1, 'water', 'Bottled Water', 93, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(204, 1, 'water', 'Water Containers', 57, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(205, 1, 'funding', 'Emergency Fund', 31, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(206, 1, 'water', 'Water Containers', 53, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(207, 1, 'water', 'Bottled Water', 52, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(208, 1, 'funding', 'Emergency Fund', 72, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(209, 1, 'water', 'Bottled Water', 11, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(210, 1, 'water', 'Water Containers', 48, 'Test request for Colombo district', 'Colombo', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(211, 1, 'funding', 'Relief Fund', 81, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(212, 1, 'water', 'Water Containers', 47, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(213, 1, 'funding', 'Emergency Fund', 61, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(214, 1, 'medicine', 'Pain Relievers', 100, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(215, 1, 'food', 'Canned Food', 11, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(216, 1, 'funding', 'Emergency Fund', 48, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(217, 1, 'water', 'Bottled Water', 94, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(218, 1, 'funding', 'Relief Fund', 19, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(219, 1, 'funding', 'Emergency Fund', 83, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(220, 1, 'food', 'Flour', 12, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(221, 1, 'medicine', 'First Aid Kit', 99, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(222, 1, 'funding', 'Emergency Fund', 95, 'Test request for Gampaha district', 'Gampaha', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(223, 1, 'medicine', 'Antibiotics', 74, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(224, 1, 'water', 'Bottled Water', 47, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(225, 1, 'medicine', 'Pain Relievers', 77, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(226, 1, 'funding', 'Relief Fund', 46, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(227, 1, 'medicine', 'First Aid Kit', 70, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(228, 1, 'food', 'Canned Food', 40, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(229, 1, 'food', 'Sugar', 13, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(230, 1, 'water', 'Water Containers', 99, 'Test request for Kalutara district', 'Kalutara', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(231, 1, 'food', 'Rice', 23, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(232, 1, 'water', 'Water Containers', 82, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(233, 1, 'food', 'Canned Food', 47, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(234, 1, 'funding', 'Relief Fund', 51, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(235, 1, 'funding', 'Emergency Fund', 28, 'Test request for Kandy district', 'Kandy', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(236, 1, 'water', 'Water Containers', 80, 'Test request for Matale district', 'Matale', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(237, 1, 'funding', 'Emergency Fund', 33, 'Test request for Matale district', 'Matale', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(238, 1, 'funding', 'Emergency Fund', 38, 'Test request for Matale district', 'Matale', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(239, 1, 'medicine', 'First Aid Kit', 25, 'Test request for Galle district', 'Galle', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(240, 1, 'medicine', 'Pain Relievers', 93, 'Test request for Galle district', 'Galle', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(241, 1, 'water', 'Water Containers', 21, 'Test request for Matara district', 'Matara', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(242, 1, 'food', 'Flour', 27, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(243, 1, 'water', 'Water Containers', 56, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(244, 1, 'funding', 'Emergency Fund', 42, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(245, 1, 'food', 'Rice', 100, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(246, 1, 'funding', 'Emergency Fund', 66, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(247, 1, 'medicine', 'Pain Relievers', 35, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(248, 1, 'medicine', 'First Aid Kit', 17, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(249, 1, 'medicine', 'First Aid Kit', 86, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(250, 1, 'funding', 'Emergency Fund', 64, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(251, 1, 'funding', 'Relief Fund', 24, 'Test request for Hambantota district', 'Hambantota', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(252, 1, 'food', 'Canned Food', 99, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(253, 1, 'water', 'Water Containers', 45, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(254, 1, 'food', 'Flour', 81, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(255, 1, 'food', 'Rice', 79, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(256, 1, 'funding', 'Relief Fund', 21, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(257, 1, 'funding', 'Relief Fund', 15, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(258, 1, 'funding', 'Emergency Fund', 36, 'Test request for Jaffna district', 'Jaffna', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(259, 1, 'water', 'Bottled Water', 58, 'Test request for Batticaloa district', 'Batticaloa', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(260, 1, 'medicine', 'Pain Relievers', 70, 'Test request for Batticaloa district', 'Batticaloa', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(261, 1, 'water', 'Water Containers', 13, 'Test request for Batticaloa district', 'Batticaloa', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(262, 1, 'funding', 'Emergency Fund', 77, 'Test request for Batticaloa district', 'Batticaloa', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(263, 1, 'water', 'Bottled Water', 68, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(264, 1, 'medicine', 'Antibiotics', 81, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(265, 1, 'food', 'Sugar', 78, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(266, 1, 'medicine', 'First Aid Kit', 22, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(267, 1, 'food', 'Rice', 45, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(268, 1, 'food', 'Sugar', 92, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(269, 1, 'food', 'Rice', 96, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(270, 1, 'funding', 'Emergency Fund', 41, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(271, 1, 'funding', 'Relief Fund', 74, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(272, 1, 'water', 'Bottled Water', 80, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(273, 1, 'water', 'Water Containers', 76, 'Test request for Trincomalee district', 'Trincomalee', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(274, 1, 'water', 'Water Containers', 25, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(275, 1, 'water', 'Water Containers', 79, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(276, 1, 'food', 'Rice', 97, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(277, 1, 'medicine', 'Antibiotics', 87, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(278, 1, 'medicine', 'Antibiotics', 26, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(279, 1, 'medicine', 'Antibiotics', 11, 'Test request for Kurunegala district', 'Kurunegala', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(280, 1, 'food', 'Canned Food', 78, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(281, 1, 'food', 'Flour', 94, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(282, 1, 'food', 'Canned Food', 52, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(283, 1, 'medicine', 'Pain Relievers', 73, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(284, 1, 'water', 'Bottled Water', 51, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(285, 1, 'food', 'Flour', 95, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(286, 1, 'medicine', 'First Aid Kit', 17, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(287, 1, 'medicine', 'Antibiotics', 95, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(288, 1, 'water', 'Bottled Water', 91, 'Test request for Anuradhapura district', 'Anuradhapura', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(289, 1, 'water', 'Water Containers', 45, 'Test request for Badulla district', 'Badulla', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16'),
(290, 1, 'water', 'Water Containers', 79, 'Test request for Badulla district', 'Badulla', 'pending', '2026-01-06 07:46:16', '2026-01-06 07:46:16');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('4VqaEmxds9NVunu0BUhp3ZzNX0icLBOvScmdC1pX', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiblRvdWJjekg5dUEwYkd5YnlMQnpjajllR0xsZzNvYTNpaU1FOGdHWCI7czo2OiJsb2NhbGUiO3M6MjoiZW4iO3M6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjM4OiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvcmVsaWVmL2RvbmF0aW9ucyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7fQ==', 1767735622);

-- --------------------------------------------------------

--
-- Table structure for table `sos_alerts`
--

CREATE TABLE `sos_alerts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `user_phone` varchar(255) DEFAULT NULL,
  `emergency_contact` varchar(255) DEFAULT NULL,
  `police_contact` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `location_details` text DEFAULT NULL,
  `is_danger_area` tinyint(1) NOT NULL DEFAULT 0,
  `alert_level` varchar(255) NOT NULL DEFAULT 'stage_1',
  `alert_time` time NOT NULL,
  `sms_recipients` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`sms_recipients`)),
  `sms_message` text DEFAULT NULL,
  `sms_sent` tinyint(1) NOT NULL DEFAULT 0,
  `sms_status` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'open',
  `closed_at` timestamp NULL DEFAULT NULL,
  `closed_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sos_alerts`
--

INSERT INTO `sos_alerts` (`id`, `user_id`, `user_name`, `user_phone`, `emergency_contact`, `police_contact`, `latitude`, `longitude`, `location_details`, `is_danger_area`, `alert_level`, `alert_time`, `sms_recipients`, `sms_message`, `sms_sent`, `sms_status`, `status`, `closed_at`, `closed_by`, `created_at`, `updated_at`) VALUES
(1, 3, 'User', '234537668', '+94 740001141', '+94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:33:09', '[{\"type\":\"emergency\",\"number\":\"+94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"failed\",\"message\":\"SMS gateway not configured\"}]', 'Alert from the user\n\nUser: User\nPhone: 234537668\nWarning Status: DANGER AREA (Isolated)\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:33:09\n\nPlease respond immediately.', 0, 'failed', 'open', NULL, NULL, '2026-01-06 10:03:09', '2026-01-06 10:03:09'),
(2, 3, 'User', '234537668', '+94 740001141', '+94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:33:16', '[{\"type\":\"emergency\",\"number\":\"+94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"failed\",\"message\":\"SMS gateway not configured\"}]', 'Alert from the user\n\nUser: User\nPhone: 234537668\nWarning Status: DANGER AREA (Isolated)\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:33:16\n\nPlease respond immediately.', 0, 'failed', 'open', NULL, NULL, '2026-01-06 10:03:16', '2026-01-06 10:03:16'),
(3, 3, 'User', '234537668', '+94 740001141', '+94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:33:23', '[{\"type\":\"emergency\",\"number\":\"+94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"failed\",\"message\":\"SMS gateway not configured\"}]', 'Alert from the user\n\nUser: User\nPhone: 234537668\nWarning Status: DANGER AREA (Isolated)\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:33:23\n\nPlease respond immediately.', 0, 'failed', 'open', NULL, NULL, '2026-01-06 10:03:23', '2026-01-06 10:03:23'),
(4, 3, 'User', '234537668', '+94 740001141', '+94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:33:29', '[{\"type\":\"emergency\",\"number\":\"+94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"failed\",\"message\":\"SMS gateway not configured\"}]', 'Alert from the user\n\nUser: User\nPhone: 234537668\nWarning Status: DANGER AREA (Isolated)\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:33:29\n\nPlease respond immediately.', 0, 'failed', 'open', NULL, NULL, '2026-01-06 10:03:29', '2026-01-06 10:03:29'),
(5, 3, 'GTA', '234537668', '+94 740001141', '+94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:33:51', '[{\"type\":\"emergency\",\"number\":\"+94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"failed\",\"message\":\"SMS gateway not configured\"}]', 'Alert from the user\n\nUser: GTA\nPhone: 234537668\nWarning Status: DANGER AREA (Isolated)\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:33:51\n\nPlease respond immediately.', 0, 'failed', 'open', NULL, NULL, '2026-01-06 10:03:51', '2026-01-06 10:03:51'),
(6, 3, 'GTA', '234537668', '+94 740001141', '+94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:38:29', '[{\"type\":\"emergency\",\"number\":\"+94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"failed\",\"message\":\"SMS gateway not configured\"}]', 'Alert from the user\n\nUser: GTA\nPhone: 234537668\nWarning Status: DANGER AREA (Isolated)\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:38:29\n\nPlease respond immediately.', 0, 'failed', 'open', NULL, NULL, '2026-01-06 10:08:29', '2026-01-06 10:08:29'),
(7, 3, 'GTA', '234537668', '+94 740001141', '+94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:38:41', '[{\"type\":\"emergency\",\"number\":\"+94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"failed\",\"message\":\"SMS gateway not configured\"}]', 'Alert from the user\n\nUser: GTA\nPhone: 234537668\nWarning Status: DANGER AREA (Isolated)\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:38:41\n\nPlease respond immediately.', 0, 'failed', 'open', NULL, NULL, '2026-01-06 10:08:41', '2026-01-06 10:08:41'),
(8, 3, 'GTA', '234537668', '+94 740001141', '+94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:39:45', '[{\"type\":\"emergency\",\"number\":\"+94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"failed\",\"message\":\"SMS gateway not configured\"}]', 'Alert from the user\n\nUser: GTA\nPhone: 234537668\nWarning Status: DANGER AREA (Isolated)\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:39:45\n\nPlease respond immediately.', 0, 'failed', 'open', NULL, NULL, '2026-01-06 10:09:45', '2026-01-06 10:09:45'),
(9, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:42:21', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"failed\",\"message\":\"cURL error 60: SSL certificate problem: unable to get local issuer certificate (see https:\\/\\/curl.haxx.se\\/libcurl\\/c\\/libcurl-errors.html) for https:\\/\\/app.notify.lk\\/api\\/v1\\/send?user_id=24720&api_key=vuXW1OXuw1NcDgj5HwAx&sender_id=NotifyDEMO&to=94740001141&message=Alert%20from%20the%20user%0A%0AUser%3A%20GTA%0APhone%3A%20234537668%0AWarning%20Status%3A%20DANGER%20AREA%20%28Isolated%29%0A%0ALocation%3A%20Giant%20Nawada%20tree%2C%20Weddagala-Kudawa%20Road%2C%20Kudawa%2C%20Ratnapura%20District%2C%20Sabaragamuwa%20Province%2C%20Sri%20Lanka%0ACoordinates%3A%206.4166983%2C%2080.4167%0AMap%3A%20https%3A%2F%2Fwww.google.com%2Fmaps%3Fq%3D6.4166983%2C80.4167%0ATime%3A%202026-01-06%2015%3A42%3A21%0A%0APlease%20respond%20immediately.\"}]', 'Alert from the user\n\nUser: GTA\nPhone: 234537668\nWarning Status: DANGER AREA (Isolated)\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:42:21\n\nPlease respond immediately.', 0, 'failed', 'open', NULL, NULL, '2026-01-06 10:12:21', '2026-01-06 10:12:22'),
(10, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:42:33', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"failed\",\"message\":\"cURL error 60: SSL certificate problem: unable to get local issuer certificate (see https:\\/\\/curl.haxx.se\\/libcurl\\/c\\/libcurl-errors.html) for https:\\/\\/app.notify.lk\\/api\\/v1\\/send?user_id=24720&api_key=vuXW1OXuw1NcDgj5HwAx&sender_id=NotifyDEMO&to=94740001141&message=Alert%20from%20the%20user%0A%0AUser%3A%20GTA%0APhone%3A%20234537668%0AWarning%20Status%3A%20DANGER%20AREA%20%28Isolated%29%0A%0ALocation%3A%20Giant%20Nawada%20tree%2C%20Weddagala-Kudawa%20Road%2C%20Kudawa%2C%20Ratnapura%20District%2C%20Sabaragamuwa%20Province%2C%20Sri%20Lanka%0ACoordinates%3A%206.4166983%2C%2080.4167%0AMap%3A%20https%3A%2F%2Fwww.google.com%2Fmaps%3Fq%3D6.4166983%2C80.4167%0ATime%3A%202026-01-06%2015%3A42%3A33%0A%0APlease%20respond%20immediately.\"}]', 'Alert from the user\n\nUser: GTA\nPhone: 234537668\nWarning Status: DANGER AREA (Isolated)\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:42:33\n\nPlease respond immediately.', 0, 'failed', 'open', NULL, NULL, '2026-01-06 10:12:33', '2026-01-06 10:12:33'),
(11, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:43:58', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"success\",\"message\":\"Sent\"}]', 'Alert from the user\n\nUser: GTA\nPhone: 234537668\nWarning Status: DANGER AREA (Isolated)\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:43:58\n\nPlease respond immediately.', 1, 'success', 'open', NULL, NULL, '2026-01-06 10:13:58', '2026-01-06 10:13:59'),
(12, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:52:10', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:52:10\n\nPlease respond immediately.', 1, 'success', 'open', NULL, NULL, '2026-01-06 10:22:10', '2026-01-06 10:22:11'),
(13, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:53:00', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:53:00\n\nPlease respond immediately.', 1, 'success', 'open', NULL, NULL, '2026-01-06 10:23:00', '2026-01-06 10:23:01'),
(14, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '15:59:01', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 15:59:01\n\nPlease respond immediately.', 1, 'success', 'open', NULL, NULL, '2026-01-06 10:29:01', '2026-01-06 10:29:02'),
(15, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '16:00:03', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 16:00:03\n\nPlease respond immediately.', 1, 'success', 'open', NULL, NULL, '2026-01-06 10:30:04', '2026-01-06 10:30:04'),
(16, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '16:03:19', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 16:03:19\n\nPlease respond immediately.', 1, 'success', 'open', NULL, NULL, '2026-01-06 10:33:19', '2026-01-06 10:33:20'),
(17, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '16:06:09', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 16:06:09\n\nPlease respond immediately.', 1, 'success', 'open', NULL, NULL, '2026-01-06 10:36:09', '2026-01-06 10:36:10'),
(18, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '16:07:06', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 16:07:06\n\nPlease respond immediately.', 1, 'success', 'open', NULL, NULL, '2026-01-06 10:37:06', '2026-01-06 10:37:07'),
(19, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '16:11:07', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 16:11:07\n\nPlease respond immediately.', 1, 'success', 'open', NULL, NULL, '2026-01-06 10:41:07', '2026-01-06 10:41:08'),
(20, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '16:11:44', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 16:11:44\n\nPlease respond immediately.', 1, 'success', 'closed', '2026-01-06 11:14:41', 1, '2026-01-06 10:41:44', '2026-01-06 11:14:41'),
(21, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_1', '16:13:13', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 16:13:13\n\nPlease respond immediately.', 1, 'success', 'open', NULL, NULL, '2026-01-06 10:43:13', '2026-01-06 10:43:14'),
(22, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_2', '21:52:58', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_2\",\"status\":\"success\",\"message\":\"Sent\"},{\"type\":\"police\",\"number\":\"94 740001141\",\"alert_level\":\"stage_2\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING SERIOUS DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 21:52:58\n\nIMMEDIATE ACTION REQUIRED\nThis is a SERIOUS EMERGENCY. User needs immediate assistance.', 1, 'success', 'open', NULL, NULL, '2026-01-06 10:52:59', '2026-01-06 10:53:00'),
(23, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_2', '22:09:44', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_2\",\"status\":\"success\",\"message\":\"Sent\"},{\"type\":\"police\",\"number\":\"94 740001141\",\"alert_level\":\"stage_2\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING SERIOUS DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 22:09:44\n\nIMMEDIATE ACTION REQUIRED\nThis is a SERIOUS EMERGENCY. User needs immediate assistance.', 1, 'success', 'open', NULL, NULL, '2026-01-06 11:09:45', '2026-01-06 11:09:47'),
(24, 3, 'User', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_2', '23:54:27', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_2\",\"status\":\"success\",\"message\":\"Sent\"},{\"type\":\"police\",\"number\":\"94 740001141\",\"alert_level\":\"stage_2\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING SERIOUS DANGER ⚠️\n\nAlert from: User\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-06 23:54:27\n\nIMMEDIATE ACTION REQUIRED\nThis is a SERIOUS EMERGENCY. User needs immediate assistance.', 1, 'success', 'open', NULL, NULL, '2026-01-06 12:54:28', '2026-01-06 12:54:30'),
(25, 3, 'GTA', '234537668', '94 740001141', '94 740001141', NULL, NULL, 'Location not available', 0, 'stage_1', '03:03:59', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_1\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nTime: 2026-01-07 03:03:59\n\nPlease respond immediately.', 1, 'success', 'open', NULL, NULL, '2026-01-06 16:04:05', '2026-01-06 16:04:07'),
(26, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_2', '03:09:10', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_2\",\"status\":\"success\",\"message\":\"Sent\"},{\"type\":\"police\",\"number\":\"94 740001141\",\"alert_level\":\"stage_2\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING SERIOUS DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-07 03:09:10\n\nIMMEDIATE ACTION REQUIRED\nThis is a SERIOUS EMERGENCY. User needs immediate assistance.', 1, 'success', 'open', NULL, NULL, '2026-01-06 16:09:12', '2026-01-06 16:09:13'),
(27, 1, 'Voice Alert User (Stage 3)', '', '94740001141', '94740001141', 6.88420000, 79.86160000, 'Colombo, Western Province, Sri Lanka', 1, 'stage_3', '21:47:01', '[{\"type\":\"emergency\",\"number\":\"94740001141\",\"alert_level\":\"stage_3\",\"status\":\"success\",\"message\":\"Sent\"},{\"type\":\"police\",\"number\":\"94740001141\",\"alert_level\":\"stage_3\",\"status\":\"success\",\"message\":\"Sent\"}]', '🚨 DANGER DANGER DANGER 🚨\n\n⚠️ CRITICAL AGGRESSIVE ALERT ⚠️\n⚠️ VERY DANGEROUS SITUATION ⚠️\n\n🚨 SERIOUS THREAT DETECTED 🚨\n🚨 IMMEDIATE DANGER AHEAD 🚨\n\n⚠️ AGGRESSIVE BEHAVIOR ALERT ⚠️\n⚠️ POTENTIALLY DANGEROUS AREA ⚠️\n\nEmergency triggered by voice-activated Stage 3 system.\nUser may be in DANGEROUS and AGGRESSIVE situation.\n\n📍 Location: Colombo, Western Province, Sri Lanka\n📍 Coordinates: 6.884200, 79.861600\n📍 Map: https://www.google.com/maps?q=6.8842,79.8616\n\n⏰ Time: 2026-01-07 03:17:00\n\n🚨 THIS IS A STAGE 3 CRITICAL EMERGENCY 🚨\n🚨 IMMEDIATE RESPONSE REQUIRED 🚨\n🚨 USER NEEDS URGENT ASSISTANCE 🚨\n\n⚠️ POTENTIALLY DANGEROUS SITUATION ⚠️\n⚠️ AGGRESSIVE THREAT IDENTIFIED ⚠️', 1, 'success', 'open', NULL, NULL, '2026-01-06 16:17:01', '2026-01-06 16:17:02'),
(28, 1, 'Voice Alert User (Stage 3)', '', '94740001141', '94740001141', 6.88420000, 79.86160000, 'Colombo, Western Province, Sri Lanka', 1, 'stage_3', '21:52:53', '[{\"type\":\"emergency\",\"number\":\"94740001141\",\"alert_level\":\"stage_3\",\"status\":\"success\",\"message\":\"Sent\"},{\"type\":\"police\",\"number\":\"94740001141\",\"alert_level\":\"stage_3\",\"status\":\"success\",\"message\":\"Sent\"}]', '🚨 DANGER DANGER DANGER 🚨\n\n⚠️ CRITICAL AGGRESSIVE ALERT ⚠️\n⚠️ VERY DANGEROUS SITUATION ⚠️\n\n🚨 SERIOUS THREAT DETECTED 🚨\n🚨 IMMEDIATE DANGER AHEAD 🚨\n\n⚠️ AGGRESSIVE BEHAVIOR ALERT ⚠️\n⚠️ POTENTIALLY DANGEROUS AREA ⚠️\n\nEmergency triggered by voice-activated Stage 3 system.\nUser may be in DANGEROUS and AGGRESSIVE situation.\n\n📍 Location: Colombo, Western Province, Sri Lanka\n📍 Coordinates: 6.884200, 79.861600\n📍 Map: https://www.google.com/maps?q=6.8842,79.8616\n\n⏰ Time: 2026-01-07 03:22:53\n\n🚨 THIS IS A STAGE 3 CRITICAL EMERGENCY 🚨\n🚨 IMMEDIATE RESPONSE REQUIRED 🚨\n🚨 USER NEEDS URGENT ASSISTANCE 🚨\n\n⚠️ POTENTIALLY DANGEROUS SITUATION ⚠️\n⚠️ AGGRESSIVE THREAT IDENTIFIED ⚠️', 1, 'success', 'open', NULL, NULL, '2026-01-06 16:22:53', '2026-01-06 16:22:55'),
(29, 3, 'GTA', '234537668', '94 740001141', '94 740001141', 6.41669830, 80.41670000, 'Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka', 1, 'stage_2', '03:23:09', '[{\"type\":\"emergency\",\"number\":\"94 740001141\",\"alert_level\":\"stage_2\",\"status\":\"success\",\"message\":\"Sent\"},{\"type\":\"police\",\"number\":\"94 740001141\",\"alert_level\":\"stage_2\",\"status\":\"success\",\"message\":\"Sent\"}]', '⚠️ WARNING SERIOUS DANGER ⚠️\n\nAlert from: GTA\nPhone: 234537668\nWarning Status: Very Danger Area\n\nLocation: Giant Nawada tree, Weddagala-Kudawa Road, Kudawa, Ratnapura District, Sabaragamuwa Province, Sri Lanka\nCoordinates: 6.4166983, 80.4167\nMap: https://www.google.com/maps?q=6.4166983,80.4167\nTime: 2026-01-07 03:23:09\n\nIMMEDIATE ACTION REQUIRED\nThis is a SERIOUS EMERGENCY. User needs immediate assistance.', 1, 'success', 'open', NULL, NULL, '2026-01-06 16:23:10', '2026-01-06 16:23:11');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`) VALUES
(1, 'admin', '$2y$12$e552o0p96a9fT8H8fEOS0.dlzeor3jL0IOVj1A/GOk0Hh2GuQ.5VC', 'admin');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `face_sessions`
--
ALTER TABLE `face_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `face_sessions_created_by_foreign` (`created_by`);

--
-- Indexes for table `face_session_images`
--
ALTER TABLE `face_session_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `face_session_images_face_session_id_index` (`face_session_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mobile_users`
--
ALTER TABLE `mobile_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mobile_users_email_unique` (`email`);

--
-- Indexes for table `relief_donations`
--
ALTER TABLE `relief_donations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `relief_donations_user_id_foreign` (`user_id`);

--
-- Indexes for table `relief_requests`
--
ALTER TABLE `relief_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `relief_requests_user_id_foreign` (`user_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `sos_alerts`
--
ALTER TABLE `sos_alerts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sos_alerts_user_id_index` (`user_id`),
  ADD KEY `sos_alerts_alert_time_index` (`alert_time`),
  ADD KEY `sos_alerts_alert_level_index` (`alert_level`),
  ADD KEY `sos_alerts_sms_sent_index` (`sms_sent`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_unique` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `face_sessions`
--
ALTER TABLE `face_sessions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `face_session_images`
--
ALTER TABLE `face_session_images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `mobile_users`
--
ALTER TABLE `mobile_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `relief_donations`
--
ALTER TABLE `relief_donations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `relief_requests`
--
ALTER TABLE `relief_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=291;

--
-- AUTO_INCREMENT for table `sos_alerts`
--
ALTER TABLE `sos_alerts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `face_sessions`
--
ALTER TABLE `face_sessions`
  ADD CONSTRAINT `face_sessions_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `face_session_images`
--
ALTER TABLE `face_session_images`
  ADD CONSTRAINT `face_session_images_face_session_id_foreign` FOREIGN KEY (`face_session_id`) REFERENCES `face_sessions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `relief_donations`
--
ALTER TABLE `relief_donations`
  ADD CONSTRAINT `relief_donations_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `mobile_users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `relief_requests`
--
ALTER TABLE `relief_requests`
  ADD CONSTRAINT `relief_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `mobile_users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sos_alerts`
--
ALTER TABLE `sos_alerts`
  ADD CONSTRAINT `sos_alerts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `mobile_users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
