var EditorCoupons = React.createClass({
    getInitialState: function() {
        return { items: this.props.items, current_selection: this.props.current_item, event_slug: this.props.event_slug, category: 'coupons' }
    },
    render: function() {
        return (

            <div className="editor-tool editor-panel-left-nav" id="editor-tool-coupons" >

               <EditorSection items={this.state.items} current_selection={this.state.current_selection} event_slug={this.state.event_slug} category={this.state.category} />
                           
            </div>
        )
    } 
});