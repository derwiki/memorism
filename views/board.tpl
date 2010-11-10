<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Memorisms</title>
        <link type="text/css" href="css/redmond/jquery-ui-1.8.6.custom.css" rel="stylesheet" />
        <link rel="stylesheet" type="text/css" href="css/basic-quickflips.css" />
        <script type="text/javascript" src="js/jquery-1.4.2.min.js">
        </script>
        <script type="text/javascript" src="js/jquery-ui-1.8.6.custom.min.js">
        </script>
        <script type="text/javascript" src="js/jquery.quickflip.source.js">
        </script>
    </head>
    <script type="application/javascript">
        var memorism = {};
		memorism.constants = {};
		memorism.actions = {};
        memorism.constants.numberOfTerms = 15;
        memorism.first_choice = null;
        
        memorism.actions.loadTerms = function(){
            var page = '/term_tuples/1088936/' + memorism.constants.numberOfTerms;
            memorism.board = new Array(memorism.constants.numberOfTerms * 2);
            
            $.getJSON(page, {}, function(data){
                var i = 0;
                for (i = 0; i < memorism.constants.numberOfTerms; i++) {
                    var firstIndex = 2 * i;
                    var secondIndex = 2 * i + 1;
                    
                    memorism.board[firstIndex] = {};
                    memorism.board[firstIndex].cleared = false;
                    memorism.board[firstIndex].term = data[i][0];
                    memorism.board[firstIndex].answer = data[i][1];
                    
                    memorism.board[secondIndex] = {};
                    memorism.board[secondIndex].cleared = false;
                    memorism.board[secondIndex].term = data[i][0];
                    memorism.board[secondIndex].answer = data[i][1];
                }
				
				memorism.actions.shuffleBoard();
            });
        }
        
        memorism.actions.shuffleBoard = function(){
            var i = 0;
            var length = memorism.constants.numberOfTerms * 2;
            for (i = 0; i < length; i++) {
            
                if (memorism.board[i].cleared) {
                    continue;
                }
                
                var tmp = null;
                
                tmp = memorism.board[i];
                
                var swapped = false;
                
                while (!swapped) {
                    var switchIndex = Math.floor(Math.random() * length);
                    
                    if (memorism.board[switchIndex].cleared) {
                        continue;
                    }
					
					memorism.board[i] = memorism.board[switchIndex];
					memorism.board[switchIndex] = tmp;
					
					swapped = true;
                }
            }
        }
        
        memorism.actions.loadTerms();
    </script>
	<body>
		
		<div id="board">
			% for i in range(0, 30):
				<div id="card{{i}}"></div>
			% end 
		</div>
	</body>
</html>
