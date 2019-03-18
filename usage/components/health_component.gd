extends UComponent
class_name UHealth

signal onCurrentHPUpdated( newVal );
signal onDie;

var maxHealth : float = 4 setget setMaxHP, getMaxHP
var currHealth : float = 4;

func setMaxHP( val : float ) -> void:
	maxHealth = val;
	
	if ( currHealth > maxHealth ):
		currHealth = maxHealth;

func getMaxHP() -> float:
	return maxHealth;

func addHP( val : float ) -> void:
	currHealth += val;
	
	if ( currHealth > maxHealth ):
		currHealth = maxHealth;
	
	emit_signal( "onCurrentHPUpdated", currHealth );

func minHP( val : float ) -> void:
	currHealth -= val;
	
	if ( currHealth <= 0 ):
		currHealth = 0;
		emit_signal( "onDie" );
	
	emit_signal( "onCurrentHPUpdated", currHealth );

func getAsPercentage() -> float:
	return currHealth * maxHealth * 100.0;

func _className():
	return "UHealth";