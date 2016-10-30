var EditorCoupons = React.createClass({
    getInitialState: function() {
        return { items: this.props.items, current_selection: this.props.current_item, event: this.props.event }
    },
    render: function() {
        return (

            <div className="editor-tool editor-panel-left-nav" id="editor-tool-coupons" >

               <EditorSection items={this.props.items} current_selection={this.props.current_selection} event={this.props.event} category={'coupons'} />
                           
            </div>
        )
    } 
});