var EditorAsideNav = React.createClass({
    getInitialState: function() {
        return { items: this.props.items}
    },
    getDefaultProps: function() {
        return { items: []}
    },

    componentDidMount: function() {
   
    },

    selectItem: function(item) {
        this.props.handleSelectItem(item);
    },

    render: function() {


        return (
            <ul className="editor-aside editor-aside-nav">
               
                {this.state.items.map(function(item, index){
                     return <EditorAsideNavItem key={index} item={item.ticket_object} handleSelectEvent={this.selectItem} />
                 }.bind(this))} 
   
                <a href="#" className="edit-aside-nav-add"><h4>+ Add New Ticket Type</h4> </a>
              
            </ul>
        )
   } 
});
