extends ParallaxBackground

@onready var sky_sprite = $Sky/Sprite2D
@onready var grass_sprite = $Grass/Sprite2D
@onready var clouds_sprite = $Clouds/Sprite2D

@export var fields_sky_texture: Texture
@export var fields_grass_texture: Texture
@export var fields_clouds_texture: Texture

@export var forest_sky_texture: Texture
@export var forest_grass_texture: Texture
@export var forest_clouds_texture: Texture

@export var desert_sky_texture: Texture
@export var desert_grass_texture: Texture
@export var desert_clouds_texture: Texture

@export var volcano_sky_texture: Texture
@export var volcano_grass_texture: Texture
@export var volcano_clouds_texture: Texture

@export var water_sky_texture: Texture
@export var water_grass_texture: Texture
@export var water_clouds_texture: Texture

func change_background_to_forest():
	sky_sprite.texture = forest_sky_texture
	grass_sprite.texture = forest_grass_texture
	clouds_sprite.texture = forest_clouds_texture

func change_background_to_fields():
	sky_sprite.texture = fields_sky_texture
	grass_sprite.texture = fields_grass_texture
	clouds_sprite.texture = fields_clouds_texture

func change_background_to_desert():
	sky_sprite.texture = desert_sky_texture
	grass_sprite.texture = desert_grass_texture
	clouds_sprite.texture = desert_clouds_texture

func change_background_to_volcano():
	sky_sprite.texture = volcano_sky_texture
	grass_sprite.texture = volcano_grass_texture
	clouds_sprite.texture = volcano_clouds_texture

func change_background_to_water():
	sky_sprite.texture = water_sky_texture
	grass_sprite.texture = water_grass_texture
	clouds_sprite.texture = water_clouds_texture
