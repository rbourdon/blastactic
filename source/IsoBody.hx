package;

import nape.geom.AABB;
import nape.geom.IsoFunction;
import nape.geom.Vec2;
import nape.geom.MarchingSquares;
import nape.phys.Body;
import nape.shape.Polygon;

class IsoBody 
{
    public static function run(iso:IsoFunctionDef, bounds:AABB, granularity:Vec2=null, quality:Int=5, simplification:Float=1) {
        var body = new Body();
        if (granularity==null) granularity = Vec2.weak(8, 8);
        var polys = MarchingSquares.run(iso, bounds, granularity, quality);
        for (p in polys) {
            var qolys = p.simplify(simplification).convexDecomposition(true);
            for (q in qolys) {
                body.shapes.add(new Polygon(q));
                // Recycle GeomPoly and its vertices
                q.dispose();
            }
            // Recycle list nodes
            qolys.clear();
            // Recycle GeomPoly and its vertices
            p.dispose();
        }
        // Recycle list nodes
        polys.clear();
        // Align body with its centre of mass.
        // Keeping track of our required graphic offset.
        //var pivot = body.localCOM.mul(-1);
        //body.translateShapes(pivot);
        //body.userData.graphicOffset = pivot;
        return body;
    }
}