class_name TerrainDetector
extends Area2D

signal entered_portal;

const terrain_bitmask = 255;

var current_tilemap: TileMap;
var previous_terrain: int = -1;
var current_terrain: int = -1;

func _ready():
	pass # Replace with function body.

func _exit_tree():
	current_tilemap = null;
	current_terrain = -1;

func _process_tilemap_collision(body: Node2D, body_rid: RID):
	current_tilemap = body;
	
	var collided_tile_coords = current_tilemap.get_coords_for_body_rid(body_rid);
	
	for index in current_tilemap.get_layers_count():
		var tile_data = current_tilemap.get_cell_tile_data(index, collided_tile_coords)
		if !tile_data is TileData:
			continue;
			
		var teleport_id: int = tile_data.get_custom_data_by_layer_id(0);
		if teleport_id > 0:
			var teleport_linked_world: String = tile_data.get_custom_data_by_layer_id(1);
			var teleport_linked_id: int = tile_data.get_custom_data_by_layer_id(2);
			teleport(teleport_id, teleport_linked_world, teleport_linked_id);



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func teleport(teleport_id: int, teleport_linked_world: String, teleport_linked_id: int):
	var parent_world: Node2D = get_parent().get_parent();
	var linked_world: TileMap = parent_world.load_world(teleport_linked_world);
	
