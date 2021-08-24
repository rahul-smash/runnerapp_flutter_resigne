package com.marketplace_service_provider;

import android.Manifest;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.BitmapFactory;
import android.location.Location;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.IBinder;
import android.os.Looper;
import android.provider.Settings;
import android.util.Log;

import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;

import java.util.HashMap;
import java.util.Map;


public class TrackerService extends Service {

    private static final String TAG = TrackerService.class.getSimpleName();
    private static final long UPDATE_INTERVAL_IN_MILLISECONDS = 30000;
    private FusedLocationProviderClient mFusedLocationClient;
    private LocationRequest locationRequest;
    private LocationSettingsRequest locationSettingsRequest;
    //Location Callback
    private LocationCallback locationCallback = new LocationCallback() {
        @Override
        public void onLocationResult(LocationResult locationResult) {
            super.onLocationResult(locationResult);
            Location currentLocation = locationResult.getLastLocation();
            Log.d("Locations", currentLocation.getLatitude() + "," + currentLocation.getLongitude());
            //Share/Publish Location
            //String userId = PrefHelper.getInstance().getSharedValue(AppConstant.ID);
            //PrefHelper.getInstance().storeSharedValue("lat", String.valueOf(currentLocation.getLatitude()));
            //PrefHelper.getInstance().storeSharedValue("lon", String.valueOf(currentLocation.getLongitude()));

            callNetworkServiceUpdateLocation(String.valueOf(currentLocation.getLatitude()), String.valueOf(currentLocation.getLongitude()));
        }
    };

    public boolean isNetworkAvailable() {
        ConnectivityManager cm =
                (ConnectivityManager) getApplicationContext().getSystemService(Context.CONNECTIVITY_SERVICE);

        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
        boolean isConnected = activeNetwork != null &&
                activeNetwork.isConnectedOrConnecting();

        return isConnected;
    }

    private void callNetworkServiceUpdateLocation(String lat, String lng) {
        Map<String, String> param = new HashMap<String, String>();
        param.put("lat", lat);
        param.put("lng", lng);
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "onCreate: ");
        initData();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d(TAG, "onStartCommand: ");
        prepareForegroundNotification();
        startLocationUpdates();
        return START_NOT_STICKY;
    }

    private void startLocationUpdates() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return;
        }

        mFusedLocationClient.requestLocationUpdates(this.locationRequest, this.locationCallback, Looper.myLooper());
    }

    private void initData() {
        locationRequest = LocationRequest.create();
        locationRequest.setInterval(UPDATE_INTERVAL_IN_MILLISECONDS);
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);

        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(getApplicationContext());
    }

    private void prepareForegroundNotification() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                    "Channel_001",
                    "Location Service Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this,
                1,
                notificationIntent, 0);
        notificationIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);

        Notification notification = new NotificationCompat.Builder(this, "Channel_001")
                .setContentTitle("Service Provide")
                .setSmallIcon(R.drawable.ic_notification)
                .setLargeIcon(BitmapFactory.decodeResource(this.getResources(), R.drawable.ic_notification))
                .setContentIntent(pendingIntent).
                        setVibrate(new long[]{1000, 1000}).
                        setSound(Settings.System.DEFAULT_NOTIFICATION_URI)

                .build();
        startForeground(12, notification);
    }

    private void requestLocationUpdates() {

        Log.d(TAG, "requestLocationUpdates: ");
        LocationRequest request = new LocationRequest();
        request.setInterval(10000);
        request.setFastestInterval(10000);
        request.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        FusedLocationProviderClient client = LocationServices.getFusedLocationProviderClient(this);

        //String userId = PrefHelper.getInstance().getSharedValue(AppConstant.ID);

        // final String path = getString(R.string.firebase_path) + "/" + userId;
        int permission = ContextCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION);
        if (permission == PackageManager.PERMISSION_GRANTED) {
            // Request location updates and when an update is
            // received, store the location in Firebase
               /* client.requestLocationUpdates(request, new LocationCallback() {
                    @Override
                    public void onLocationResult(LocationResult locationResult) {
                        DatabaseReference ref = FirebaseDatabase.getInstance().getReference(path);
                        Location location = locationResult.getLastLocation();
                        if (location != null) {
                           // Log.d(TAG, "location update " + location);
                            ref.setValue(location);
                        }
                    }
                }, null);*/
        }
    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {
        super.onTaskRemoved(rootIntent);
        Log.d(TAG, "onTaskRemoved: ");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.d(TAG, "onDestroy: ");
    }
}
