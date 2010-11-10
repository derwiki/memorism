<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Memorisms</title>
        <link type="text/css" href="css/redmond/jquery-ui-1.8.6.custom.css" rel="stylesheet" />
        <link rel="stylesheet" type="text/css" href="css/basic-quickflips.css" />
		<link rel="stylesheet" type="text/css" href="css/memorism.css" />
        <script type="text/javascript" src="js/jquery-1.4.2.min.js">
        </script>
        <script type="text/javascript" src="js/jquery-ui-1.8.6.custom.min.js">
        </script>
        <script type="text/javascript" src="js/jquery.quickflip.source.js">
        </script>
    <script type="application/javascript">
//shuffles list in-place
		var shuffle = function(list) {
		  var i, j, t;
		  for (i = 1; i < list.length; i++) {
			j = Math.floor(Math.random()*(1+i));  // choose j in [0..i]
			if (j != i) {
			  t = list[i];                        // swap list[i] and list[j]
			  list[i] = list[j];
			  list[j] = t;
			}
		  }
		};

        var memorism = {};
		memorism.constants = {};
		memorism.actions = {};
        memorism.constants.numberOfTerms = 15;
        memorism.first_choice = null;
        
        memorism.actions.loadTerms = function(){
            var page = '/term_tuples/1088936/' + memorism.constants.numberOfTerms;
			memorism.boardSlots = [];
			memorism.definitions = [];
            
            $.getJSON(page, {}, function(data){
				memorism.data = data;
				data.forEach(function(term, index){
					memorism.boardSlots.push({
						id: index,
						term: term[0],
						cleared: false
					});
					memorism.boardSlots.push({
						id: index,
						definition: term[1]
					});
					memorism.definitions.push({
						id: index,
						term: term[0],
						definition: term[1],
						cleared: false
					});
					console.log(memorism.boardSlots[index])
				});
				shuffle(memorism.boardSlots);
			});
        };
      
		$(document).ready(function(){
			memorism.actions.loadTerms();
		});

    </script>
	</head>
	<body>
		
		<div id="board">
			% for i in range(0, 30):
				<div id="card{{i}}" class="card">
					<div class="panel1">Front</div>
					<div class="panel2">Back</div>
				</div>
			% end
		</div>
	</body>
</html>
