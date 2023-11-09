using Godot;
using System;

public partial class Player : CharacterBody3D
{


	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		//Input.MouseMode = Input.MouseModeEnum.Confined;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

  public override void _Input(InputEvent @event)
    {
        base._Input(@event);
		if (@event is InputEventMouseMotion mousePos) {
			Rotation = Rotation with {Y = (float)(Math.Atan2(mousePos.Relative.Y - Position.Y, mousePos.Relative.X - Position.X))}; 
			GD.Print((float)(Math.Atan2(mousePos.Relative.Y - Position.Y, mousePos.Relative.X - Position.X) * 180 / Math.PI));
		}
		
    }
}
