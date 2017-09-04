-- phpMyAdmin SQL Dump
-- version 3.4.4
-- http://www.phpmyadmin.net
--
-- Client: 127.0.0.1
-- Généré le : Lun 24 Février 2014 à 14:29
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
-- Structure de la table `articulation`
--

CREATE TABLE IF NOT EXISTS `articulation` (
  `CodeArticulation` smallint(6) NOT NULL DEFAULT '0',
  `NomArticulation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `NomAbrege` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Code Divers` smallint(6) DEFAULT NULL,
  `Selecte` bit(1) DEFAULT NULL,
  `Selecte1` bit(1) DEFAULT NULL,
  PRIMARY KEY (`CodeArticulation`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `articulation`
--

INSERT INTO `articulation` (`CodeArticulation`, `NomArticulation`, `NomAbrege`, `Code Divers`, `Selecte`, `Selecte1`) VALUES
(1, 'consonant', 'cons', 0, b'0', b'0'),
(2, 'vowel', 'vowel', 0, b'0', b'0'),
(3, 'diphtong', 'diph', 1, b'0', b'0'),
(5, 'stop', 'stp', 1, b'0', b'0'),
(6, 'implosive', 'implosiv', 1, b'0', b'0'),
(7, 'nasal', 'nasal', 1, b'0', b'0'),
(8, 'trill', 'trill', 1, b'0', b'0'),
(9, 'tap', 'tap', 1, b'0', b'0'),
(10, 'flap', 'flap', 1, b'0', b'0'),
(11, 'r-sound', 'rsound', 1, b'0', b'0'),
(12, 'fricative', 'fricative', 1, b'0', b'0'),
(13, 'affricate', 'affricate', 1, b'0', b'0'),
(14, 'affricate-lateral', 'afrilat', 1, b'0', b'0'),
(15, 'lateral-fricative', 'laterfricativ', 1, b'0', b'0'),
(16, 'lateral', 'lateral', 1, b'0', b'0'),
(17, 'lateral-approximant', 'laterapprox', 1, b'0', b'0'),
(18, 'approximant', 'approxi', 1, b'0', b'0'),
(19, 'click', 'click', 1, b'0', b'0'),
(30, 'bilabial', 'bilabial', 2, b'0', b'0'),
(31, 'labiodental', 'labdent', 2, b'0', b'0'),
(32, 'labial-palatal', 'labpal', 2, b'0', b'0'),
(33, 'labial-velar', 'labvel', 2, b'0', b'0'),
(34, 'dental', 'dental', 2, b'0', b'0'),
(35, 'alveolar', 'alveolar', 2, b'0', b'0'),
(36, 'postalveolar', 'postalveol', 2, b'0', b'0'),
(37, 'retroflex', 'retro', 2, b'0', b'0'),
(38, 'palatal', 'palatal', 2, b'0', b'0'),
(39, 'velar', 'velar', 2, b'0', b'0'),
(40, 'velar-alveolar', 'velalveo', 2, b'0', b'0'),
(41, 'uvular', 'uvular', 2, b'0', b'0'),
(42, 'pharyngeal', 'phary', 2, b'0', b'0'),
(43, 'epiglottal', 'epiglott', 2, b'0', b'0'),
(44, 'glottal', 'glottal', 2, b'0', b'0'),
(45, 'laryngeal', 'lary', 2, b'0', b'0'),
(50, 'linguolabial', 'linglab', 5, b'0', b'0'),
(51, 'pharyngealized', 'pharzd', 5, b'0', b'0'),
(52, 'aspirated', 'aspirate', 5, b'0', b'0'),
(53, 'glottalized', 'glotazed', 5, b'0', b'0'),
(54, 'labialized', 'labzd', 5, b'0', b'0'),
(55, 'lateral-release', 'latrel', 5, b'0', b'0'),
(56, 'palatalized', 'palzd', 5, b'0', b'0'),
(57, 'ejective', 'ejective', 5, b'0', b'0'),
(58, 'nasal-release', 'nasrel', 5, b'0', b'0'),
(59, 'velarized', 'velzd', 5, b'0', b'0'),
(60, 'with-breathy-release', 'wbr', 5, b'0', b'0'),
(61, 'velar-fricated', 'velfricd', 5, b'0', b'0'),
(62, 'nasalized', 'naszd', 5, b'0', b'0'),
(63, 'advanced', 'advad', 5, b'0', b'0'),
(64, 'retracted', 'retactd', 5, b'0', b'0'),
(65, 'raised', 'raisd', 5, b'0', b'0'),
(66, 'lowered', 'lored', 5, b'0', b'0'),
(67, 'long', 'long', 5, b'0', b'0'),
(68, 'lip-compressed', 'lipcomp', 5, b'0', b'0'),
(69, 'sibilant', 'sib', 5, b'0', b'0'),
(70, 'voiced', 'vd', NULL, b'0', b'0'),
(71, 'voiceless', 'vl', 5, b'0', b'0'),
(72, 'breathy-voiced', 'breathy', 5, b'0', b'0'),
(73, 'creaky-voiced', 'creaky', 2, b'0', b'0'),
(74, 'retroflexed', 'retrfld', NULL, b'0', b'0'),
(75, 'ad-tg-root', 'atroot', NULL, b'0', b'0'),
(76, 'overshort', 'ovrshort', NULL, b'0', b'0'),
(77, 'preaspirated', 'preasp', 4, b'0', b'0'),
(78, 'prenasalized', 'prenazad', 4, b'0', b'0'),
(79, 'prestopped', 'pstop', 4, b'0', b'0'),
(80, 'preglottalized', 'pglot', 4, b'0', b'0'),
(85, 'high', 'high', 4, b'0', b'0'),
(86, 'lowered-high', 'lordhig', 4, b'0', b'0'),
(87, 'higher-mid', 'himid', 4, b'0', b'0'),
(88, 'mid', 'md', 4, b'0', b'0'),
(89, 'lower-mid', 'lomid', 4, b'0', b'0'),
(90, 'raised-low', 'raidlo', 4, b'0', b'0'),
(91, 'low', 'low', 4, b'0', b'0'),
(92, 'front', 'front', NULL, b'0', b'0'),
(93, 'central', 'central', NULL, b'0', b'0'),
(94, 'back', 'back', NULL, b'0', b'0'),
(95, 'peripheral', 'perif', NULL, b'0', b'0'),
(96, 'rounded', 'rounded', NULL, b'0', b'0'),
(97, 'unrounded', 'unrnd', NULL, b'0', b'0'),
(100, 'to high back rounded', 'thbr', NULL, b'0', b'0'),
(101, 'to high back unrounded', 'thbu', 0, b'0', b'0'),
(102, 'to high central rounded', 'thcr', 0, b'0', b'0'),
(103, 'to high central unrounded', 'thcu', NULL, b'0', b'0'),
(104, 'to high front rounded', 'thfr', 0, b'0', b'0'),
(105, 'to high front unrounded', 'thfu', 0, b'0', b'0'),
(106, 'to higher-mid back rounded', 'thmbro', 0, b'0', b'0'),
(107, 'to higher-mid front rounded', 'thmfr', 0, b'0', b'0'),
(108, 'to higher-mid front unrounded', 'thmfu', 0, b'0', b'0'),
(109, 'to labial-velar approximant', 'tlva', 0, b'0', b'0'),
(110, 'to low central unrounded', 'tlcu', 0, b'0', b'0'),
(111, 'to low front unrounded', 'tlfu', 0, b'0', b'0'),
(112, 'to lower-mid back rounded', 'ltmbr', 0, b'0', b'0'),
(113, 'to lower-mid back unrounded', 'tlmbu', 0, b'0', b'0'),
(114, 'to lower-mid front unrounded', 'tlmfu', 0, b'0', b'0'),
(115, 'to mid central unrounded', 'tmcu', 0, b'0', b'0'),
(116, 'to palatal approximant', 'tpa', 0, b'0', b'0');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
