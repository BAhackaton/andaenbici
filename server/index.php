<?php

   // Database connection settings
   define("PG_DB"  , "routing");
   define("PG_HOST", "localhost"); 
   define("PG_USER", "postgres");
   define("PG_PORT", "5432"); 
   define("TABLE",   "calles");

   // Retrieve start point
   $start = split(' ',$_REQUEST['startpoint']);
   $startPoint = array($start[0], $start[1]);

   // Retrieve end point
   $end = split(' ',$_REQUEST['finalpoint']);
   $endPoint = array($end[0], $end[1]);
   
   // Connect to database
   $dbcon = pg_connect("dbname=".PG_DB." host=".PG_HOST." user=".PG_USER);

   // Find the nearest edge
   $startEdge = findNearestEdge($startPoint, $dbcon);
   $endEdge   = findNearestEdge($endPoint, $dbcon);

   $sql = 	"SELECT nomb_ca_co as hombre, least(alt_ii, alt_di) as desde, greatest(alt_if, alt_df) as hasta, tipo_c, ST_AsGeoJSON(rt.the_geom) as geom FROM shortest_path('
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

		$edge['geom'] = json_decode($edge['geom']; 
 		array_push($geojson, $edge);
   }

	
   // Close database connection
   pg_close($dbcon);

   // Return routing result
   header('Content-type: application/json',true);
   echo json_encode($geojson);


   // FUNCTION findNearestEdge
   function findNearestEdge($lonlat, $con) {

      $sql = "SELECT gid, source, target, the_geom, 
		          distance(the_geom, GeometryFromText(
	                   'POINT(".$lonlat[0]." ".$lonlat[1].")', 4326)) AS dist 
	             FROM ".TABLE."  
	             WHERE the_geom && setsrid(
	                   'BOX3D(".($lonlat[0]-0.1)." 
	                          ".($lonlat[1]-0.1).", 
	                          ".($lonlat[0]+0.1)." 
	                          ".($lonlat[1]+0.1).")'::box3d, 4326) 
	             ORDER BY dist LIMIT 1";

      $query = pg_query($con,$sql);  

      $edge['gid']      = pg_fetch_result($query, 0, 0);  
      $edge['source']   = pg_fetch_result($query, 0, 1);  
      $edge['target']   = pg_fetch_result($query, 0, 2);  
      $edge['the_geom'] = pg_fetch_result($query, 0, 3);  

      return $edge;
   }