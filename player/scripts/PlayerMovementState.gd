class_name PlayerMovementState extends Node;

var velocity = Vector2.ZERO
var maxSpeed = 200
var acceleration = 1000
var airAcceleration = 500
var jumpVelocity = -500
var dashVelocity = 1000
var dashDuration = 0.2
var isDashing = false
var dashDirection = Vector2.ZERO
var dashTimer = 0.0
var isOnFloor = false;

func update(delta: float) -> Vector2:
	calculateMovement(delta)
	applyFriction(delta)
	applyGravity(delta)
	return velocity;

func calculateMovement(delta: float):
	var inputDir = Vector2.RIGHT if Input.is_action_pressed("move_right") else Vector2.LEFT if Input.is_action_pressed("move_left") else Vector2.ZERO
	var desiredVel = inputDir * (dashVelocity if isDashing else (maxSpeed if isOnFloor else airAcceleration))
	
	velocity = velocity.lerp(desiredVel, acceleration * delta if isOnFloor else airAcceleration * delta)
	
	if Input.is_action_just_pressed("jump") and isOnFloor:
		print("jump")
		velocity.y = jumpVelocity
	
	if Input.is_action_just_pressed("move_dash") and !isDashing:
		startDash(inputDir)

	if isDashing:
		handleDash(delta)

func startDash(direction: Vector2):
	if direction != Vector2.ZERO:
		isDashing = true
		dashDirection = direction.normalized()
		velocity = dashDirection * dashVelocity
		dashTimer = dashDuration

func handleDash(delta: float):
	dashTimer -= delta
	if dashTimer <= 0:
		isDashing = false

func applyFriction(delta: float):
	var friction = 0.5 if isOnFloor else 0.2
	velocity.x = lerp(0.0, friction * delta, velocity.x)

func applyGravity(delta: float):
	if isOnFloor:
		velocity.y += 30 * delta  # Some gravity value

func handleCollision(tilemap: TileMap, collision: KinematicCollision2D, position: Vector2, delta: float):
	var rid: RID = collision.get_collider_rid();
	var layer = tilemap.get_layer_for_body_rid(rid);
	if layer != 0: # collision tile layer
		return;
	var cellPos = tilemap.get_coords_for_body_rid(rid);
	var tileData: TileData = tilemap.get_cell_tile_data(layer, cellPos);
	var collisionPolygon = tileData.get_collision_polygon_points(0, 0);
	
	var normal = calcCollisionNormal(collisionPolygon, estimateCollisionPoint(position, velocity, collisionPolygon, delta))
	if normal.x != 0:
		# Collision with a wall (left or right)
		velocity.x = 0

	if normal.y != 0:
		# Collision with a ceiling or floor
		velocity.y = 0
		isOnFloor = true if normal.y > 0 else false;

func calcCollisionNormal(collisionPolygon: PackedVector2Array, collisionPoint):
	var closestEdgeIndex = -1
	var closestEdgeDistance = INF

	# Find the closest edge to the collision point
	for i in range(collisionPolygon.size()):
		var pointA = collisionPolygon[i]
		var pointB = collisionPolygon[(i + 1) % collisionPolygon.size()]
		
		# Calculate distance from the collision point to the edge
		var edge = pointB - pointA
		var edgeNormal = edge.normalized()
		var toPointA = collisionPoint - pointA
		var distance = toPointA.dot(edgeNormal)
	
		if distance >= 0 and distance <= edge.length():
			# Collision point lies within the edge
			if distance < closestEdgeDistance:
				closestEdgeIndex = i
				closestEdgeDistance = distance

	# Calculate the normal of the closest edge
	if closestEdgeIndex >= 0:
		var pointA = collisionPolygon[closestEdgeIndex]
		var pointB = collisionPolygon[(closestEdgeIndex + 1) % collisionPolygon.size()]
		var edge = pointB - pointA
		return Vector2(-edge.y, edge.x).normalized()
	else:
		return Vector2.ZERO  # No collision or invalid polygon

func estimateCollisionPoint(position, velocity, collisionPolygon, delta):
	# Estimate the next position based on the velocity
	var nextPosition = position + velocity * delta;

	var collisionPoint = Vector2.ZERO
	var minDistance = INF

	# Loop through the edges of the collision polygon
	for i in range(collisionPolygon.size()):
		var pointA = collisionPolygon[i]
		var pointB = collisionPolygon[(i + 1) % collisionPolygon.size()]
	
		# Calculate the intersection point between the velocity vector and the edge
		var intersection = _intersectionPoint(position, nextPosition, pointA, pointB)

		# Check if there is an intersection and calculate distance
		if intersection != Vector2.INF:
			var distance = position.distance_to(intersection)

			# Update collisionPoint if this intersection is closer
			if distance < minDistance:
				collisionPoint = intersection
				minDistance = distance

	return collisionPoint

	# Helper function to find intersection point between a line segment and a line
func _intersectionPoint(p1, p2, q1, q2):
	var r = p2 - p1
	var s = q2 - q1
	var qp = q1 - p1

	var r_cross_s = r.cross(s)
	var qp_cross_r = qp.cross(r)

	# Check if lines are parallel or colinear
	if r_cross_s == 0 and qp_cross_r == 0:
		return Vector2.INF  # Lines are either parallel or colinear

	var t = qp.cross(s) / r_cross_s
	var u = qp_cross_r / r_cross_s

	# Check for intersection within line segments
	if 0 <= t and t <= 1 and 0 <= u and u <= 1:
		return p1 + t * r
	else:
		return Vector2.INF  # No intersection or outside line segments
