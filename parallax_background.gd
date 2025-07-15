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

func change_background_to_forest():
	sky_sprite.texture = forest_sky_texture
	grass_sprite.texture = forest_grass_texture
	clouds_sprite.texture = forest_clouds_texture

func change_background_to_fields():
	sky_sprite.texture = fields_sky_texture
	grass_sprite.texture = fields_grass_texture
	clouds_sprite.texture = fields_clouds_texture
