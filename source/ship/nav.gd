extends NavigationRegion3D


# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("update_navmesh")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_navmesh():
	await get_tree().physics_frame
	# use bake and update function of region
	var on_thread: bool = true
	bake_navigation_mesh(on_thread)

	# or use the NavigationMeshGenerator singleton
	var _navigationmesh: NavigationMesh = navigation_mesh
	NavigationMeshGenerator.bake(_navigationmesh, self)
	# remove old resource first to trigger a full update
	navigation_mesh = null
	navigation_mesh = _navigationmesh

	# or use NavigationServer API to update region with prepared navigation mesh
	var region_rid: RID = get_region_rid()
	NavigationServer3D.region_set_navigation_mesh(region_rid, navigation_mesh)
