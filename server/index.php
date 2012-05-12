<?php

// Database connection settings
   define("PG_DB"  , "routing");
   define("PG_HOST", "localhost"); 
   define("PG_USER", "postgres");
   define("PG_PORT", "5432"); 
   define("TABLE",   "calles");

   // Retrieve start point
   $start = split(',',$_REQUEST['startpoint']);
   $startPoint = array($start[1], $start[0]);

   // Retrieve end point
   $end = split(',',$_REQUEST['finalpoint']);
   $endPoint = array($end[1], $end[0]);
   
   // Connect to database
   $dbcon = pg_connect("dbname=".PG_DB." host=".PG_HOST." user=".PG_USER);

   // Find the nearest edge
   $startEdge = findNearestEdge($startPoint, $dbcon);
   $endEdge   = findNearestEdge($endPoint, $dbcon);

   $sql = 	"SELECT nomb_ca_co as nombre, least(alt_ii, alt_di) as desde, greatest(alt_if, alt_df) as hasta, tipo_c, ST_AsGeoJSON(geom) as geom FROM shortest_path('
                SELECT gid as id,
                         source::integer,
                         target::integer,
                         peso::double precision as cost
                        FROM " . TABLE . "',
                ".$startEdge['source'].",
                ".$endEdge['target'].", false, false) sp left join " . TABLE . " c2 on c2.gid = sp.edge_id";

   // Perform database query
   $query = pg_query($dbcon,$sql); 
   
   // Return route as GeoJSON
   $geojson = array(); 
  
   // Add edges to GeoJSON array
   while($edge=pg_fetch_assoc($query)) {  

		$edge['geom'] = json_decode($edge['geom']); 
 		array_push($geojson, $edge);
   }

	
   // Close database connection
   pg_close($dbcon);

   // Return routing result
   header('Content-type: application/json',true);
   echo json_encode($geojson, true);


   // FUNCTION findNearestEdge
   function findNearestEdge($lonlat, $con) {

      $sql = "SELECT gid, source, target, geom, nomb_ca_co, 
		          distance(geom, GeometryFromText(
	                   'POINT(".$lonlat[0]." ".$lonlat[1].")', 4326)) AS dist 
	             FROM ".TABLE."
	             WHERE geom && setsrid(
	                   'BOX3D(".($lonlat[0]-0.1)." 
	                          ".($lonlat[1]-0.1).", 
	                          ".($lonlat[0]+0.1)." 
	                          ".($lonlat[1]+0.1).")'::box3d, 4326) 
	             ORDER BY dist LIMIT 1";

      $query = pg_query($con,$sql);  

      $result = pg_fetch_assoc($query); 
	return $result;      

   }
