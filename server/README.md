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
