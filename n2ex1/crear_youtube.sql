-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP DATABASE IF EXISTS youtube;
-- -----------------------------------------------------
-- Schema youtube
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema youtube
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `youtube` DEFAULT CHARACTER SET utf8 ;
USE `youtube` ;

-- -----------------------------------------------------
-- Table `youtube`.`pais`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`pais` (
  `id_pais` INT(3) NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NULL,
  PRIMARY KEY (`id_pais`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`usuari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`usuari` (
  `id_usuari` INT(13) NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NULL,
  `password` VARCHAR(45) NULL,
  `nom_usuari` VARCHAR(45) NULL,
  `data_naixement` DATE NULL,
  `sexe` ENUM('Male', 'Female', 'Other') NULL,
  `pais_id` INT(3) NOT NULL,
  `codi_postal` VARCHAR(6) NULL,
  PRIMARY KEY (`id_usuari`, `pais_id`),
  CONSTRAINT `fk_usuari_pais1`
    FOREIGN KEY (`pais_id`)
    REFERENCES `youtube`.`pais` (`id_pais`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `email_UNIQUE` ON `youtube`.`usuari` (`email` ASC) VISIBLE;

CREATE UNIQUE INDEX `nom_usuari_UNIQUE` ON `youtube`.`usuari` (`nom_usuari` ASC) VISIBLE;

CREATE INDEX `fk_usuari_pais1_idx` ON `youtube`.`usuari` (`pais_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `youtube`.`video`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`video` (
  `id_video` INT(15) NOT NULL AUTO_INCREMENT,
  `titol` VARCHAR(45) NULL,
  `descripcio` TEXT NULL,
  `grandaria` INT NULL,
  `nom_arxiu` VARCHAR(45) NULL,
  `durada` TIME NULL,
  `thumbnail` VARCHAR(45) NULL,
  `nombre_reproduccions` INT(15) NULL,
  `nombre_likes` INT(15) NULL,
  `nombre_dislikes` INT(15) NULL,
  `estat` ENUM('públic', 'ocult', 'privat') NULL,
  `usuari_id` INT(13) NOT NULL,
  `data_hora_publicacio` DATETIME NULL,
  PRIMARY KEY (`id_video`, `usuari_id`),
  CONSTRAINT `fk_video_usuari1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `youtube`.`usuari` (`id_usuari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `nom_arxiu_UNIQUE` ON `youtube`.`video` (`nom_arxiu` ASC) VISIBLE;

CREATE INDEX `fk_video_usuari1_idx` ON `youtube`.`video` (`usuari_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `youtube`.`etiqueta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`etiqueta` (
  `id_etiqueta` INT(15) NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(30) NULL,
  PRIMARY KEY (`id_etiqueta`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`like_video`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`like_video` (
  `id_like_video` INT NOT NULL AUTO_INCREMENT,
  `usuari_id` INT(15) NOT NULL,
  `video_id` INT(15) NOT NULL,
  `data_hora` DATETIME NULL,
  `tipus` ENUM('like', 'dislike') NULL,
  PRIMARY KEY (`id_like_video`, `usuari_id`, `video_id`),
  CONSTRAINT `fk_like_video_usuari1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `youtube`.`usuari` (`id_usuari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_like_video_video1`
    FOREIGN KEY (`video_id`)
    REFERENCES `youtube`.`video` (`id_video`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_like_video_usuari1_idx` ON `youtube`.`like_video` (`usuari_id` ASC) VISIBLE;

CREATE INDEX `fk_like_video_video1_idx` ON `youtube`.`like_video` (`video_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `youtube`.`canal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`canal` (
  `id_canal` INT(15) NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(30) NULL,
  `descripcio` TINYTEXT NULL,
  `data_creacio` DATETIME NULL,
  `creador_id` INT(15) NOT NULL,
  PRIMARY KEY (`id_canal`, `creador_id`),
  CONSTRAINT `fk_canal_usuari1`
    FOREIGN KEY (`creador_id`)
    REFERENCES `youtube`.`usuari` (`id_usuari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `nom_UNIQUE` ON `youtube`.`canal` (`nom` ASC) VISIBLE;

CREATE INDEX `fk_canal_usuari1_idx` ON `youtube`.`canal` (`creador_id` ASC) VISIBLE;

CREATE UNIQUE INDEX `creador_id_UNIQUE` ON `youtube`.`canal` (`creador_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `youtube`.`playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`playlist` (
  `id_playlist` INT(15) NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NULL,
  `data_creacio` DATETIME NULL,
  `estat` ENUM('pública', 'privada') NULL,
  `usuari_id` INT(15) NOT NULL,
  `video_id` INT(15) NOT NULL,
  PRIMARY KEY (`id_playlist`, `video_id`),
  CONSTRAINT `fk_playlist_usuari1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `youtube`.`usuari` (`id_usuari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_playlist_video1`
    FOREIGN KEY (`video_id`)
    REFERENCES `youtube`.`video` (`id_video`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_playlist_usuari1_idx` ON `youtube`.`playlist` (`usuari_id` ASC) VISIBLE;

CREATE INDEX `fk_playlist_video1_idx` ON `youtube`.`playlist` (`video_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `youtube`.`comentari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`comentari` (
  `id_comentari` INT(20) NOT NULL AUTO_INCREMENT,
  `text` TEXT NULL,
  `data_hora` DATETIME NULL,
  `usuari_id` INT(15) NOT NULL,
  `video_id` INT(15) NOT NULL,
  PRIMARY KEY (`id_comentari`, `usuari_id`, `video_id`),
  CONSTRAINT `fk_comentari_usuari1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `youtube`.`usuari` (`id_usuari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comentari_video1`
    FOREIGN KEY (`video_id`)
    REFERENCES `youtube`.`video` (`id_video`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_comentari_usuari1_idx` ON `youtube`.`comentari` (`usuari_id` ASC) VISIBLE;

CREATE INDEX `fk_comentari_video1_idx` ON `youtube`.`comentari` (`video_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `youtube`.`like_comentari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`like_comentari` (
  `id_like_comentari` INT(20) NOT NULL AUTO_INCREMENT,
  `comentari_id` INT(20) NOT NULL,
  `usuari_id` INT(15) NOT NULL,
  `data_hora` DATETIME NULL,
  `tipus` ENUM('like', 'dislike') NULL,
  PRIMARY KEY (`id_like_comentari`, `usuari_id`, `comentari_id`),
  CONSTRAINT `fk_like_comentari_usuari1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `youtube`.`usuari` (`id_usuari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_like_comentari_comentari1`
    FOREIGN KEY (`comentari_id`)
    REFERENCES `youtube`.`comentari` (`id_comentari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_like_comentari_usuari1_idx` ON `youtube`.`like_comentari` (`usuari_id` ASC) VISIBLE;

CREATE INDEX `fk_like_comentari_comentari1_idx` ON `youtube`.`like_comentari` (`comentari_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `youtube`.`etiquetes_videos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`etiquetes_videos` (
  `id_ev` INT NOT NULL AUTO_INCREMENT,
  `etiqueta_id` INT(15) NOT NULL,
  `video_id` INT(15) NOT NULL,
  PRIMARY KEY (`id_ev`, `video_id`, `etiqueta_id`),
  CONSTRAINT `fk_etiquetes_videos_etiqueta`
    FOREIGN KEY (`etiqueta_id`)
    REFERENCES `youtube`.`etiqueta` (`id_etiqueta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_etiquetes_videos_video1`
    FOREIGN KEY (`video_id`)
    REFERENCES `youtube`.`video` (`id_video`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_etiquetes_videos_etiqueta_idx` ON `youtube`.`etiquetes_videos` (`etiqueta_id` ASC) VISIBLE;

CREATE INDEX `fk_etiquetes_videos_video1_idx` ON `youtube`.`etiquetes_videos` (`video_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `youtube`.`usuaris_canals`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`usuaris_canals` (
  `id_uc` INT NOT NULL AUTO_INCREMENT,
  `subscriptor_id` INT(15) NOT NULL,
  `canal_id` INT(15) NOT NULL,
  PRIMARY KEY (`id_uc`, `subscriptor_id`, `canal_id`),
  CONSTRAINT `fk_usuaris_canals_usuari1`
    FOREIGN KEY (`subscriptor_id`)
    REFERENCES `youtube`.`usuari` (`id_usuari`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuaris_canals_canal1`
    FOREIGN KEY (`canal_id`)
    REFERENCES `youtube`.`canal` (`id_canal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_usuaris_canals_usuari1_idx` ON `youtube`.`usuaris_canals` (`subscriptor_id` ASC) VISIBLE;

CREATE INDEX `fk_usuaris_canals_canal1_idx` ON `youtube`.`usuaris_canals` (`canal_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `youtube`.`playlists_videos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`playlists_videos` (
  `id_pv` INT NOT NULL AUTO_INCREMENT,
  `playlist_id` INT(15) NOT NULL,
  `video_id` INT(15) NOT NULL,
  PRIMARY KEY (`id_pv`, `playlist_id`, `video_id`),
  CONSTRAINT `fk_playlists_videos_playlist1`
    FOREIGN KEY (`playlist_id`)
    REFERENCES `youtube`.`playlist` (`id_playlist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_playlists_videos_video1`
    FOREIGN KEY (`video_id`)
    REFERENCES `youtube`.`video` (`id_video`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_playlists_videos_playlist1_idx` ON `youtube`.`playlists_videos` (`playlist_id` ASC) VISIBLE;

CREATE INDEX `fk_playlists_videos_video1_idx` ON `youtube`.`playlists_videos` (`video_id` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
