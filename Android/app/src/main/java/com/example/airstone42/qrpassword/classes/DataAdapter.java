package com.example.airstone42.qrpassword.classes;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.example.airstone42.qrpassword.R;

import java.util.List;

public class DataAdapter extends ArrayAdapter<PasswordData> {
    public int resourseId;

    public DataAdapter(Context context, int textViewResourceId, List<PasswordData> objects) {
        super(context, textViewResourceId, objects);
        resourseId = textViewResourceId;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        PasswordData passwordData = getItem(position);
        View view = LayoutInflater.from(getContext()).inflate(resourseId, parent, false);
        TextView itemTitle = (TextView) view.findViewById(R.id.list_item_title);
        TextView itemUsername = (TextView) view.findViewById(R.id.list_item_username);
        itemTitle.setText(passwordData.getWebsite());
        itemUsername.setText(passwordData.getUsername());
        return view;
    }
}
