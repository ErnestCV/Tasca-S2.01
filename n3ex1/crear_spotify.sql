-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP DATABASE IF EXISTS spotify;
-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `spotify` DEFAULT CHARACTER SET utf8 ;
USE `spotify` ;

-- -----------------------------------------------------
-- Table `spotify`.`pais`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`pais` (
  `id_pais` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NULL,
  PRIMARY KEY (`id_pais`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `nom_UNIQUE` ON `spotify`.`pais` (`nom` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `spotify`.`usuari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`usuari` (
  `id_usuari` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(20) NOT NULL,
  `data_naixement` DATE NULL,
  `sexe` ENUM('masculi', 'femení', 'altre') NULL,
  `pais_id` INT NOT NULL,
  `codi_postal` VARCHAR(10) NULL,
  PRIMARY KEY (`id_usuari`, `pais_id`),
  CONSTRAINT `fk_usuari_pais`
    FOREIGN KEY (`pais_id`)
    REFERENCES `spotify`.`pais` (`id_pais`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `email_UNIQUE` ON `spotify`.`usuari` (`email` ASC) VISIBLE;

CREATE INDEX `fk_usuari_pais_idx` ON `spotify`.`usuari` (`pais_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `spotify`.`usuari_premium`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`usuari_premium` (
  `usuari_id` INT NOT NULL,
  `data_inici` DATE NULL,
  `data_renovacio` DATE NULL,
  `forma_pagament` ENUM('targeta', 'paypal') NULL,
  PRIMARY KEY (`usuari_id`),
  CONSTRAINT `fk_usuari_premium_usuari1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuari` (`id_usuari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_usuari_premium_usuari1_idx` ON `spotify`.`usuari_premium` (`usuari_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `spotify`.`pagament`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`pagament` (
  `id_pagament` INT NOT NULL AUTO_INCREMENT,
  `data` DATE NULL,
  `total` FLOAT(6,2) NULL,
  PRIMARY KEY (`id_pagament`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`usuaris_pagaments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`usuaris_pagaments` (
  `id_up` INT NOT NULL AUTO_INCREMENT,
  `usuari_id` INT NOT NULL,
  `pagament_id` INT NOT NULL,
  PRIMARY KEY (`id_up`, `usuari_id`, `pagament_id`),
  CONSTRAINT `fk_usuaris_pagaments_pagament1`
    FOREIGN KEY (`pagament_id`)
    REFERENCES `spotify`.`pagament` (`id_pagament`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuaris_pagaments_usuari_premium1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuari_premium` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_usuaris_pagaments_pagament1_idx` ON `spotify`.`usuaris_pagaments` (`pagament_id` ASC) VISIBLE;

CREATE INDEX `fk_usuaris_pagaments_usuari_premium1_idx` ON `spotify`.`usuaris_pagaments` (`usuari_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `spotify`.`targeta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`targeta` (
  `numero` VARCHAR(20) NULL,
  `mes_caducitat` VARCHAR(2) NULL,
  `any_caducitat` VARCHAR(4) NULL,
  `codi_seguretat` VARCHAR(7) NULL,
  `usuari_id` INT NOT NULL,
  PRIMARY KEY (`usuari_id`),
  CONSTRAINT `fk_targeta_usuari_premium1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuari_premium` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `numero_UNIQUE` ON `spotify`.`targeta` (`numero` ASC) VISIBLE;

CREATE INDEX `fk_targeta_usuari_premium1_idx` ON `spotify`.`targeta` (`usuari_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `spotify`.`paypal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`paypal` (
  `nom_usuari` VARCHAR(45) NULL,
  `usuari_id` INT NOT NULL,
  PRIMARY KEY (`usuari_id`),
  CONSTRAINT `fk_paypal_usuari_premium1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuari_premium` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_paypal_usuari_premium1_idx` ON `spotify`.`paypal` (`usuari_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `spotify`.`playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlist` (
  `id_playlist` INT NOT NULL AUTO_INCREMENT,
  `titol` VARCHAR(45) NULL,
  `nombre_cancons` INT NULL,
  `data_creacio` DATE NULL,
  `estat` ENUM('activa', 'esborrada') NOT NULL,
  `data_eliminada` DATE NULL,
  `creador_id` INT NOT NULL,
  PRIMARY KEY (`id_playlist`, `creador_id`),
  CONSTRAINT `fk_playlist_usuari1`
    FOREIGN KEY (`creador_id`)
    REFERENCES `spotify`.`usuari` (`id_usuari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_playlist_usuari1_idx` ON `spotify`.`playlist` (`creador_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `spotify`.`artista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artista` (
  `id_artista` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NULL,
  `imatge` VARCHAR(45) NULL,
  PRIMARY KEY (`id_artista`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`album` (
  `id_album` INT NOT NULL AUTO_INCREMENT,
  `titol` VARCHAR(45) NULL,
  `any_publicacio` VARCHAR(4) NULL,
  `imatge` VARCHAR(45) NULL,
  `artista_id` INT NOT NULL,
  PRIMARY KEY (`id_album`, `artista_id`),
  CONSTRAINT `fk_album_artista1`
    FOREIGN KEY (`artista_id`)
    REFERENCES `spotify`.`artista` (`id_artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_album_artista1_idx` ON `spotify`.`album` (`artista_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `spotify`.`canco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`canco` (
  `id_canco` INT NOT NULL AUTO_INCREMENT,
  `titol` VARCHAR(45) NULL,
  `durada` TIME NULL,
  `nombre_reproduccions` INT NULL,
  `album_id` INT NOT NULL,
  PRIMARY KEY (`id_canco`, `album_id`),
  CONSTRAINT `fk_canco_album1`
    FOREIGN KEY (`album_id`)
    REFERENCES `spotify`.`album` (`id_album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_canco_album1_idx` ON `spotify`.`canco` (`album_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `spotify`.`playlists_cancons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlists_cancons` (
  `id_pc` INT NOT NULL AUTO_INCREMENT,
  `canco_id` INT NOT NULL,
  `playlist_id` INT NOT NULL,
  `usuari_afegit_id` INT NOT NULL,
  `data_afegit` DATE NULL,
  PRIMARY KEY (`id_pc`, `playlist_id`, `usuari_afegit_id`, `canco_id`),
  CONSTRAINT `fk_playlists_cancons_usuari1`
    FOREIGN KEY (`usuari_afegit_id`)
    REFERENCES `spotify`.`usuari` (`id_usuari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_playlists_cancons_playlist1`
    FOREIGN KEY (`playlist_id`)
    REFERENCES `spotify`.`playlist` (`id_playlist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_playlists_cancons_canco1`
    FOREIGN KEY (`canco_id`)
    REFERENCES `spotify`.`canco` (`id_canco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_playlists_cancons_usuari1_idx` ON `spotify`.`playlists_cancons` (`usuari_afegit_id` ASC) VISIBLE;

CREATE INDEX `fk_playlists_cancons_playlist1_idx` ON `spotify`.`playlists_cancons` (`playlist_id` ASC) VISIBLE;

CREATE INDEX `fk_playlists_cancons_canco1_idx` ON `spotify`.`playlists_cancons` (`canco_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `spotify`.`artistes_relacions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artistes_relacions` (
  `id_relacio` INT NOT NULL AUTO_INCREMENT,
  `artista_id` INT NOT NULL,
  `artista_relacionat_id` INT NOT NULL,
  PRIMARY KEY (`id_relacio`, `artista_id`, `artista_relacionat_id`),
  CONSTRAINT `fk_artistes_relacions_artista1`
    FOREIGN KEY (`artista_id`)
    REFERENCES `spotify`.`artista` (`id_artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_artistes_relacions_artista2`
    FOREIGN KEY (`artista_relacionat_id`)
    REFERENCES `spotify`.`artista` (`id_artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_artistes_relacions_artista1_idx` ON `spotify`.`artistes_relacions` (`artista_id` ASC) VISIBLE;

CREATE INDEX `fk_artistes_relacions_artista2_idx` ON `spotify`.`artistes_relacions` (`artista_relacionat_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `spotify`.`artistes_usuaris_seguidors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artistes_usuaris_seguidors` (
  `id_au` INT NOT NULL AUTO_INCREMENT,
  `artista_id` INT NOT NULL,
  `usuari_id` INT NOT NULL,
  PRIMARY KEY (`id_au`, `usuari_id`, `artista_id`),
  CONSTRAINT `fk_artistes_usuaris_artista1`
    FOREIGN KEY (`artista_id`)
    REFERENCES `spotify`.`artista` (`id_artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_artistes_usuaris_usuari1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuari` (`id_usuari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_artistes_usuaris_artista1_idx` ON `spotify`.`artistes_usuaris_seguidors` (`artista_id` ASC) VISIBLE;

CREATE INDEX `fk_artistes_usuaris_usuari1_idx` ON `spotify`.`artistes_usuaris_seguidors` (`usuari_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `spotify`.`usuari_canco_fav`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`usuari_canco_fav` (
  `id_uc` INT NOT NULL AUTO_INCREMENT,
  `usuari_id` INT NOT NULL,
  `canco_id` INT NOT NULL,
  PRIMARY KEY (`id_uc`, `usuari_id`, `canco_id`),
  CONSTRAINT `fk_usuari_canco_fav_usuari1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuari` (`id_usuari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuari_canco_fav_canco1`
    FOREIGN KEY (`canco_id`)
    REFERENCES `spotify`.`canco` (`id_canco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_usuari_canco_fav_usuari1_idx` ON `spotify`.`usuari_canco_fav` (`usuari_id` ASC) VISIBLE;

CREATE INDEX `fk_usuari_canco_fav_canco1_idx` ON `spotify`.`usuari_canco_fav` (`canco_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `spotify`.`usuari_album_fav`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`usuari_album_fav` (
  `id_au` INT NOT NULL AUTO_INCREMENT,
  `album_id` INT NOT NULL,
  `usuari_id` INT NOT NULL,
  PRIMARY KEY (`id_au`, `usuari_id`, `album_id`),
  CONSTRAINT `fk_usuari_album_fav_usuari1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuari` (`id_usuari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuari_album_fav_album1`
    FOREIGN KEY (`album_id`)
    REFERENCES `spotify`.`album` (`id_album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_usuari_album_fav_usuari1_idx` ON `spotify`.`usuari_album_fav` (`usuari_id` ASC) VISIBLE;

CREATE INDEX `fk_usuari_album_fav_album1_idx` ON `spotify`.`usuari_album_fav` (`album_id` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
