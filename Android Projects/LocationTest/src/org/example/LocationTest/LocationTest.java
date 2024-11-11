package org.example.locationtest;

import java.util.Iterator;
import java.util.List;

import android.app.Activity;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.LocationProvider;
import android.os.Bundle;
import android.widget.TextView;

public class LocationTest extends Activity implements LocationListener {
    private LocationManager mgr;
    private TextView output;
    private String best;
    
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        mgr = (LocationManager) getSystemService(LOCATION_SERVICE);
        output = (TextView) findViewById(R.id.output);
        
        //log("Location providers:");
        dumpProviders();
        
        Criteria criteria = new Criteria();
        best = mgr.getBestProvider(criteria, true);
/*        log("\nBest provider is: " + best);
        
        log("\nLocations (starting with last known): ");*/
        Location location = mgr.getLastKnownLocation(best);
        location.
        //dumpLocation(location);
    }

	@Override
	public void onLocationChanged(Location location) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onProviderDisabled(String provider) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onProviderEnabled(String provider) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onStatusChanged(String provider, int status, Bundle extras) {
		// TODO Auto-generated method stub
		
	}
	
	public void dumpProviders() {
		List<String> providers = mgr.getAllProviders();
		output.append("Number of providers: " + Integer.toString(providers.size()) + "\n");

		for (Iterator<String> iterator = providers.iterator(); iterator.hasNext();) {
			String string = iterator.next();
			output.append(string + "\n");
		}
	}

	public void dumpLocation(Location location) {
		output.append("accuracy: ");
		//float acc = location.getAccuracy();
		float acc = 0.0F;
		output.append(Float.toString(acc));
/*		if (location.hasAccuracy()) {
			output.append(Float.toString(location.getAccuracy()));
		}
		else {
			output.append("-.--");
		}*/
		output.append(" m\n");
	}

}