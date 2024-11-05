jQuery(document).ready(function($) {
    var tokensPerPage = parseInt(basescammer_ajax_object.tokens_per_page) || 50;
    var refreshRate = parseInt(basescammer_ajax_object.refresh_rate) || 300;

    function fetchTokens() {
        $.ajax({
            url: basescammer_ajax_object.api_url + '?limit=' + tokensPerPage,
            method: 'GET',
            success: function(data) {
                if (Array.isArray(data)) {
                    displayTokens(data);
                } else {
                    $('#basescammer-loading').text('Error: Invalid data received.');
                }
            },
            error: function() {
                $('#basescammer-loading').text('Error fetching tokens.');
            }
        });
    }

    function displayTokens(tokens) {
        var $tokenList = $('#basescammer-token-list');
        $tokenList.empty();

        tokens.forEach(function(token) {
            var statusIcon;
            if (token.status === 'Green') {
                statusIcon = '<span class="basescammer-status-icon basescammer-green-check">&#10004;</span>';
            } else if (token.status === 'Red') {
                statusIcon = '<span class="basescammer-status-icon basescammer-red-x">&#10060;</span>';
            } else {
                statusIcon = '<span class="basescammer-status-icon basescammer-yellow-question">&#10067;</span>';
            }

            var $tokenItem = $('<div class="basescammer-token-item">' + statusIcon + '<span class="basescammer-token-name">' + token.symbol + ' (' + token.name + ')</span></div>');
            $tokenItem.data('token', token);

            $tokenItem.click(function() {
                displayTokenInfo($(this).data('token'));
            });

            $tokenList.append($tokenItem);
        });
    }

    function displayTokenInfo(token) {
        var $tokenInfo = $('#basescammer-token-info');
        $tokenInfo.html(
            '<h3>' + token.symbol + ' (' + token.name + ')</h3>' +
            '<p><strong>Status:</strong> ' + token.status + '</p>' +
            '<p><strong>Score:</strong> ' + (token.score !== null ? token.score : 'N/A') + '</p>' +
            '<p><strong>Message:</strong> ' + token.message + '</p>' +
            '<p><strong>Market Cap:</strong> ' + (token.marketCap !== null ? '$' + token.marketCap : 'N/A') + '</p>' +
            '<p><strong>Total Supply:</strong> ' + (token.totalSupply !== null ? token.totalSupply : 'N/A') + '</p>' +
            '<p><strong>Circulating Supply:</strong> ' + (token.circulatingSupply !== null ? token.circulatingSupply : 'N/A') + '</p>' +
            '<p><strong>Liquidity Pool:</strong> ' + (token.liquidityPool !== null ? token.liquidityPool : 'N/A') + '</p>' +
            '<p><strong>Holders Count:</strong> ' + (token.holdersCount !== null ? token.holdersCount : 'N/A') + '</p>' +
            '<p><strong>Contract Address:</strong> ' + token.contractAddress + '</p>'
        );
    }

    fetchTokens();
    setInterval(fetchTokens, refreshRate);
});
