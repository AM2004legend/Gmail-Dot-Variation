async function saveEmailVariation(email) {
  try {
    const userId = sessionStorage.getItem('userId');
    const authToken = sessionStorage.getItem('authToken');
    
    console.log('saveEmailVariation called with:', email);
    console.log('userId:', userId);
    console.log('authToken exists:', !!authToken);
    
    if (!userId || !authToken) {
      console.log('Not authenticated, cannot save to database');
      return false;
    }

    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(userId)) {
      console.error('Invalid userId format:', userId);
      return false;
    }

    console.log('Inserting email into database...');
    const { data, error } = await supabase
      .from('saved_emails')
      .insert([
        {
          user_id: userId,
          email: email,
          created_at: new Date().toISOString()
        }
      ])
      .select();

    if (error) {
      if (error.code === 'PGRST116' || (error.message && error.message.includes('duplicate'))) {
        console.log('Email already saved (duplicate)');
        return true;
      }
      console.error('❌ ERROR SAVING EMAIL');
      console.error('Error code:', error.code);
      console.error('Error message:', error.message);
      console.error('Error status:', error.status);
      console.error('Error details:', error.details);
      console.error('Full error:', JSON.stringify(error, null, 2));
      return false;
    }

    console.log('Email saved successfully:', data);
    return true;
  } catch (err) {
    console.error('❌ EXCEPTION SAVING EMAIL');
    console.error('Exception message:', err.message);
    console.error('Exception name:', err.name);
    console.error('Exception stack:', err.stack);
    console.error('Full exception:', JSON.stringify(err, null, 2));
    return false;
  }
}

async function fetchSavedEmails() {
  try {
    const userId = sessionStorage.getItem('userId');
    const authToken = sessionStorage.getItem('authToken');
    
    if (!userId || !authToken) {
      return [];
    }

    const { data, error } = await supabase
      .from('saved_emails')
      .select('*')
      .eq('user_id', userId)
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Error fetching emails:', error);
      return [];
    }

    return data || [];
  } catch (err) {
    console.error('Exception fetching emails:', err);
    return [];
  }
}

async function deleteSavedEmail(emailId) {
  try {
    const { error } = await supabase
      .from('saved_emails')
      .delete()
      .eq('id', emailId);

    if (error) {
      console.error('Error deleting email:', error);
      return false;
    }

    return true;
  } catch (err) {
    console.error('Exception deleting email:', err);
    return false;
  }
}

async function updateUserProfile(updates) {
  try {
    const userId = sessionStorage.getItem('userId');
    const authToken = sessionStorage.getItem('authToken');
    
    if (!userId || !authToken) {
      return false;
    }

    const { data, error } = await supabase
      .from('user_profiles')
      .update(updates)
      .eq('user_id', userId)
      .select();

    if (error) {
      console.error('Error updating profile:', error);
      return false;
    }

    console.log('Profile updated:', data);
    return true;
  } catch (err) {
    console.error('Exception updating profile:', err);
    return false;
  }
}

async function loadSavedEmailsCount() {
  try {
    const userId = sessionStorage.getItem('userId');
    if (!userId) {
      console.log('Not authenticated, cannot load saved count');
      return 0;
    }

    const { data, error } = await supabase
      .from('saved_emails')
      .select('id', { count: 'exact', head: true })
      .eq('user_id', userId);

    if (error) {
      console.error('Error loading saved count:', error);
      return 0;
    }

    const count = data && data.length >= 0 ? data.length : 0;
    console.log('Loaded saved emails count:', count);
    return count;
  } catch (err) {
    console.error('Exception loading saved count:', err);
    return 0;
  }
}
