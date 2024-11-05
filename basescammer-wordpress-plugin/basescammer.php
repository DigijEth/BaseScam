<?php
/*
Plugin Name: BaseScammer
Description: Displays tokens from Basechain scanned by the Token Sniffer API.
Version: 1.0
Author: Your Name
*/

if (!defined('ABSPATH')) exit; // Exit if accessed directly

// Enqueue scripts and styles
function basescammer_enqueue_scripts() {
    wp_enqueue_style('basescammer-styles', plugin_dir_url(__FILE__) . 'css/styles.css');
    wp_enqueue_script('basescammer-scripts', plugin_dir_url(__FILE__) . 'js/scripts.js', array('jquery'), null, true);
    wp_localize_script('basescammer-scripts', 'basescammer_ajax_object', array(
        'ajax_url' => admin_url('admin-ajax.php'),
        'nonce'    => wp_create_nonce('basescammer_nonce'),
        'api_url'  => 'https://your-server-url.com/api/tokens', // Replace with your server URL
        'tokens_per_page' => get_option('basescammer_tokens_per_page', 50),
        'refresh_rate'    => get_option('basescammer_refresh_rate', 300),
    ));
}
add_action('wp_enqueue_scripts', 'basescammer_enqueue_scripts');

// Shortcode to display the token scanner
function basescammer_display_scanner($atts) {
    $atts = shortcode_atts(array(
        'display' => 'option1', // 'option1' or 'option2'
    ), $atts, 'basescammer_scanner');

    ob_start();
    include plugin_dir_path(__FILE__) . 'templates/scanner.php';
    return ob_get_clean();
}
add_shortcode('basescammer_scanner', 'basescammer_display_scanner');

// Add settings menu
function basescammer_add_settings_menu() {
    add_options_page('BaseScammer Settings', 'BaseScammer', 'manage_options', 'basescammer-settings', 'basescammer_render_settings_page');
}
add_action('admin_menu', 'basescammer_add_settings_menu');

// Render settings page
function basescammer_render_settings_page() {
    if (!current_user_can('manage_options')) {
        return;
    }

    // Save settings
    if (isset($_POST['basescammer_settings_submit'])) {
        check_admin_referer('basescammer_settings_nonce');
        update_option('basescammer_tokens_per_page', intval($_POST['basescammer_tokens_per_page']));
        $refresh_rate = max(intval($_POST['basescammer_refresh_rate']), 200);
        update_option('basescammer_refresh_rate', $refresh_rate);
        echo '<div class="updated"><p>Settings saved.</p></div>';
    }

    // Get settings
    $tokens_per_page = get_option('basescammer_tokens_per_page', 50);
    $refresh_rate = get_option('basescammer_refresh_rate', 300);

    ?>
    <div class="wrap">
        <h1>BaseScammer Settings</h1>
        <form method="post">
            <?php wp_nonce_field('basescammer_settings_nonce'); ?>
            <table class="form-table">
                <tr>
                    <th scope="row"><label for="basescammer_tokens_per_page">Tokens Per Page</label></th>
                    <td>
                        <select id="basescammer_tokens_per_page" name="basescammer_tokens_per_page">
                            <option value="50" <?php selected($tokens_per_page, 50); ?>>50</option>
                            <option value="75" <?php selected($tokens_per_page, 75); ?>>75</option>
                            <option value="100" <?php selected($tokens_per_page, 100); ?>>100</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><label for="basescammer_refresh_rate">Refresh Rate (ms)</label></th>
                    <td><input type="number" id="basescammer_refresh_rate" name="basescammer_refresh_rate" value="<?php echo esc_attr($refresh_rate); ?>" min="200" required></td>
                </tr>
            </table>
            <?php submit_button('Save Settings', 'primary', 'basescammer_settings_submit'); ?>
        </form>
    </div>
    <?php
}
