-- phpMyAdmin SQL Dump
-- version 3.4.4
-- http://www.phpmyadmin.net
--
-- Client: 127.0.0.1
-- Généré le : Lun 24 Février 2014 à 14:09
-- Version du serveur: 5.5.15
-- Version de PHP: 5.3.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `cassopi`
--

-- --------------------------------------------------------

--
-- Structure de la table `languesbdproto`
--

CREATE TABLE IF NOT EXISTS `languesbdproto` (
  `Nom` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Famille` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Code` smallint(6) DEFAULT NULL,
  `NbSegment` smallint(6) DEFAULT NULL,
  `Selecte` bit(1) DEFAULT NULL,
  `Selecte1` bit(1) DEFAULT NULL,
  `CodeBase` smallint(6) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `languesbdproto`
--

INSERT INTO `languesbdproto` (`Nom`, `Famille`, `Code`, `NbSegment`, `Selecte`, `Selecte1`, `CodeBase`) VALUES
('AFRO-ASIATIC', 'Afro-Asiatic', 1061, 50, b'0', b'0', 20),
('ALGONQUIAN', 'North-American, Almosan', 1097, 20, b'0', b'0', 20),
('ALTAIC', 'Ural-Altaic, Altaic', 1053, 36, b'0', b'0', 20),
('ANATOLIAN', 'Indo-European, Anatolian', 1018, 33, b'0', b'0', 20),
('ARAWAKAN', 'South-American, Macro-Arawakan', 1116, 34, b'0', b'0', 20),
('ATHAPASKAN', 'Na-Dene, Athabaskan', 1110, 43, b'0', b'0', 20),
('ATTIC', 'Indo-European, Greek', 1104, 24, b'0', b'0', 20),
('AUSTRALIAN', 'Australian', 1059, 20, b'0', b'0', 20),
('AUSTRONESIAN', 'Austro-Tai, Austronesian', 1041, 28, b'0', b'0', 20),
('BANTU', 'Niger-Kordofanian, Bantoid', 1094, 18, b'0', b'0', 20),
('CENTRAL GUR', 'Niger-Kordofanian, Voltaic', 1038, 34, b'0', b'0', 20),
('CENTRAL-KHOISAN', 'Khoisan, Central-Khoisan', 1056, 39, b'0', b'0', 20),
('CHADIC', 'Afro-Asiatic, Chadic', 1083, 33, b'0', b'0', 20),
('CHIAPANEC MANGUEAN', 'North-American, Oto-Manguean', 1072, 23, b'0', b'0', 20),
('CHIBCHA', 'South-American, Chibchan', 1111, 26, b'0', b'0', 20),
('CHIMAKUAN', 'North-American, Almosan', 1099, 39, b'0', b'0', 20),
('CHINANTECAN', 'North-American, Oto-Manguean', 1077, 28, b'0', b'0', 20),
('CHUKOTKO-KAMCHATKAN', 'Chukchi-Kamchatkan', 1113, 25, b'0', b'0', 20),
('COMMON BERBER', 'Afro-Asiatic, Berber', 1081, 20, b'0', b'0', 22),
('COMMON NORDIC', 'Indo-European, Germanic, North', 1045, 42, b'0', b'0', 20),
('COPTIC', 'Afro-Asiatic, Ancient-Egyptian', 1106, 27, b'0', b'0', 20),
('CUSHITIC', 'Afro-Asiatic, Cushitic', 1062, 50, b'0', b'0', 20),
('DRAVIDIAN', 'Dravidian', 1012, 26, b'0', b'0', 20),
('EARLY PROTO FINNIC', 'Ural-Altaic, Finno-Ugric', 1065, 29, b'0', b'0', 20),
('EAST TARIKU', 'Papuan, Geelvink-Bay', 1031, 12, b'0', b'0', 20),
('EDOID', 'Niger-Kordofanian, Kwa', 1060, 42, b'0', b'0', 20),
('ESKIMO', 'Eskimo-Aleut, Eskimo', 1007, 19, b'0', b'0', 20),
('ESKIMO-ALEUT', 'Eskimo-Aleut', 1112, 22, b'0', b'0', 20),
('FINNO-PERMIC', 'Ural-Altaic, Finno-Ugric', 1090, 32, b'0', b'0', 20),
('FINNO-UGRIC', 'Ural-Altaic, Finno-Ugric', 1068, 33, b'0', b'0', 20),
('GBAYA', 'Niger-Kordofanian, Ubangi', 1093, 42, b'0', b'0', 20),
('GERMANIC', 'Indo-European, Germanic', 1046, 9, b'0', b'0', 21),
('GOROKAN', 'Papuan, Trans-New-Guinea', 1095, 13, b'0', b'0', 20),
('GUAHIBAN', 'South-American, Macro-Arawakan', 1118, 22, b'0', b'0', 20),
('GUANG', 'Niger-Kordofanian, Voltaic', 1103, 31, b'0', b'0', 20),
('HUON GULF', 'Austro-Tai, Austronesian, East-Malayo-Polynesian', 1026, 21, b'0', b'0', 22),
('IJO', 'Niger-Kordofanian, Kwa', 1015, 30, b'0', b'0', 20),
('INDO-EUROPEAN', 'Indo-European', 1051, 38, b'0', b'0', 20),
('KARTVELIAN', 'Caucasian', 1052, 46, b'0', b'0', 20),
('KATUIC', 'Austro-Asiatic, Katuic', 1058, 36, b'0', b'0', 22),
('KERESAN', 'North-American, Keresiouan', 1109, 49, b'0', b'0', 20),
('KIMBE', 'Austro-Tai, Austronesian, East-Malayo-Polynesian', 1039, 19, b'0', b'0', 20),
('LAKES PLAIN', 'Papuan, Geelvink-Bay', 1028, 12, b'0', b'0', 20),
('LAPP', 'Ural-Altaic, Finno-Ugric', 1066, 9, b'0', b'0', 21),
('LOLO-BURMESE', 'Sino-Tibetan, Lolo-Burmese', 1082, 37, b'0', b'0', 20),
('LOWER CROSS', 'Niger-Kordofanian, Cross-River', 1014, 14, b'0', b'0', 22),
('LOWER SEPIK', 'Papuan, Sepik-Ramu', 1063, 27, b'0', b'0', 20),
('MAIDUN', 'North-American, Penutian', 1108, 29, b'0', b'0', 20),
('MALAYO POLYNESIAN', 'Austro-Tai, Austronesian', 1004, 30, b'0', b'0', 20),
('MANDE', 'Niger-Kordofanian, Mande', 1037, 16, b'0', b'0', 22),
('MANDEKAN', 'Niger-Kordofanian, Mande', 1025, 23, b'0', b'0', 20),
('MARKHAM', 'Austro-Tai, Austronesian, East-Malayo-Polynesian', 1027, 23, b'0', b'0', 20),
('MAYAN', 'North-American, Penutian', 1057, 32, b'0', b'0', 20),
('MICRONESIAN', 'Austro-Tai, Austronesian, East-Malayo-Polynesian', 1107, 21, b'0', b'0', 20),
('MIDDLE ENGLISH', 'Indo-European, Germanic, West', 1049, 6, b'0', b'0', 21),
('MIXTECAN', 'North-American, Oto-Manguean', 1070, 20, b'0', b'0', 20),
('MON', 'Austro-Asiatic, Mon', 1020, 35, b'0', b'0', 20),
('NEW CALEDONIAN', 'Austro-Tai, Austronesian, East-Malayo-Polynesian', 1021, 29, b'0', b'0', 22),
('NOSTRATIC', 'Macro-Family, Nostratic', 1055, 48, b'0', b'0', 20),
('OB UGRIC', 'Ural-Altaic, Finno-Ugric', 1089, 40, b'0', b'0', 20),
('OLD CHINESE', 'Sino-Tibetan, Sinitic', 1006, 35, b'0', b'0', 20),
('OLD TELUGU', 'Dravidian, Dravidian', 1011, 33, b'0', b'0', 20),
('ONGAMO MAA', 'Nilo-Saharan, East-Sudanic, Nilotic', 1043, 29, b'0', b'0', 20),
('OTO-MANGUEAN', 'North-American, Oto-Manguean', 1096, 11, b'0', b'0', 20),
('OTOMI', 'North-American, Oto-Manguean', 1073, 30, b'0', b'0', 20),
('PAMAN', 'Australian, Pama-Nyungan', 1100, 19, b'0', b'0', 20),
('PHILIPPINE', 'Austro-Tai, Austronesian, West-Malayo-Polynesian', 1022, 24, b'0', b'0', 20),
('PLANG', 'Austro-Asiatic, Khmer', 1017, 40, b'0', b'0', 20),
('POLYNESIAN', 'Austro-Tai, Austronesian, East-Malayo-Polynesian', 1002, 18, b'0', b'0', 20),
('POPOLOCAN', 'North-American, Oto-Manguean', 1071, 22, b'0', b'0', 20),
('PRE BASQUE', 'Isolates', 1000, 27, b'0', b'0', 20),
('PRE NIZAA', 'Niger-Kordofanian, Bantoid', 1102, 33, b'0', b'0', 20),
('PROTO-AINU', 'Ural-Altaic, Ainu', 1035, 31, b'0', b'0', 20),
('PROTO-JAPANESE', 'Ural-Altaic, Japanese', 1101, 4, b'0', b'0', 21),
('PROTO-KAREN', 'Sino-Tibetan, Karenic', 1013, 29, b'0', b'0', 20),
('PROTO-LAKKIA', 'Austro-Tai, Li-Kam-Tai', 1003, 66, b'0', b'0', 20),
('PROTO-MABA', 'Nilo-Saharan, Maban', 1023, 21, b'0', b'0', 22),
('PROTO-NUBIAN', 'Nilo-Saharan, East-Sudanic', 1044, 26, b'0', b'0', 20),
('PROTO-POMO', 'North-American, Hokan', 1115, 40, b'0', b'0', 20),
('PROTO-VIETNAMESE', 'Austro-Asiatic, Vietmuong', 1105, 28, b'0', b'0', 22),
('QUICHEAN', 'North-American, Penutian', 1010, 34, b'0', b'0', 20),
('SABAKI', 'Niger-Kordofanian, Bantoid', 1019, 35, b'0', b'0', 20),
('SALISH', 'North-American, Almosan', 1098, 48, b'0', b'0', 20),
('SAMOYED', 'Ural-Altaic, Samoyed', 1085, 25, b'0', b'0', 20),
('SANGIRIC', 'Austro-Tai, Austronesian, West-Malayo-Polynesian', 1001, 21, b'0', b'0', 20),
('SARA BONGO BAGUIRMIAN', 'Nilo-Saharan, Central-Sudanic', 1092, 33, b'0', b'0', 22),
('SEMITIC', 'Afro-Asiatic, Semitic', 1080, 35, b'0', b'0', 20),
('SUMERIAN', 'Isolates', 1054, 26, b'0', b'0', 20),
('TAI', 'Austro-Tai, Li-Kam-Tai', 1067, 49, b'0', b'0', 20),
('TAKANAN', 'South-American, Macro-Panoan', 1064, 21, b'0', b'0', 20),
('TANO CONGO', 'Niger-Kordofanian, Kwa', 1009, 14, b'0', b'0', 21),
('TOTONOCAN', 'North-American, Penutian', 1079, 23, b'0', b'0', 20),
('TUCANOAN', 'South-American, Macro-Tucanoan', 1117, 33, b'0', b'0', 20),
('TUPI-GUARANI', 'South-American, Equatorial', 1119, 25, b'0', b'0', 20),
('URALIC', 'Ural-Altaic, Uralic', 1084, 25, b'0', b'0', 20),
('URALO-SIBERIAN', 'Macro-Macro-Family, Uralo-Siberian', 1114, 29, b'0', b'0', 20),
('UTO-AZTECAN', 'North-American, Uto-Aztecan', 1069, 17, b'0', b'0', 20),
('WEST TARIKU', 'Papuan, Geelvink-Bay', 1032, 12, b'0', b'0', 20),
('YOKUTS', 'North-American, Penutian', 1008, 39, b'0', b'0', 20),
('ZAPOTECAN', 'North-American, Oto-Manguean', 1076, 20, b'0', b'0', 20),
('ZOQUEAN', 'North-American, Penutian', 1078, 20, b'0', b'0', 20);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
