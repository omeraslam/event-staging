var EditorOrders = React.createClass({
    render: function() {
        return (

            <div className="editor-tool editor-panel-top-nav" id="editor-tool-orders" >
                <BuyerList items={this.props.items} headers={this.props.headers} />
            </div>
        )
    }
})