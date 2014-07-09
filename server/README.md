Message structure
=================


```js 
// Get sensors
{
	"req": "sensor"
}
// Response:
{
	"sensors": [
		"ship": {
			"x": 23.4,
			"y": 68.1,
			"readings": [
				{
					"em": "546.3",
					"precision": "10"
				},
				{
					"gr": "23.2",
					"precision": "1"
				}
			]
		},
		"drone_1": {
			"x": 1264.265,
			"y": 689.26,
			"readings"
		},

		// etc...
	]
}
```





The Ship
========

## Sensors:

### Gravimetric

Detects massy objects. Returns direction but not distance.
Very long falloff

### Electromagnetic 

Detects electromagnetic signatures. Returns distance but not direction.
Long falloff

### Thermo-optic

Detects heat and optical signatures. Returns distance and direction.
Short falloff

## Gun

Has a capacitor which discharges to fire the projectile.
Minimum charge is 100kJ

Generates heat when charged and fired, over-heating can cause an accidental discharge, explosion, or dud.

An integrated cooling system can be powered up to allow 
