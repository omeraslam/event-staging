var EditorAsideNav = React.createClass({
    getInitialState: function() {
        return { items: this.props.items, current_selection: this.props.current_selection, handleSelectItem: this.props.handleSelectItem, category: this.props.category}
    },
    getDefaultProps: function() {
        return { items: []}
    },

    componentWillReceiveProps: function(nextProps) {
        this.setState({current_selection: nextProps.current_selection});
    },

    componentDidMount: function() {
   
    },



    addNavItem: function() {
        switch(this.state.category) {
            case 'coupon':
            var itemObj = {"promo_code": "new coupon", "discount": "0", "is_fixed": false, "is_active": false};
            break;
            case 'question':
            
            var itemObj = {"question_text": "new question item", "response_required": false, "description": "Enter more details", "answer_text": "","field_type": null, "ticket_id": null,  "event_id": null, "is_active": false, "free_text_active": false, "free_text": ""};
            
            break;
            case 'ticket':
             var itemObj = {"title": "new ticket item", "description": "1000 of 1000", "price": 0,"is_active": false, "ticket_limit": 1000, "buy_limit": 4, "stop_date": moment().format('YYYY-MM-DD')};
             default:
             break;
        }
        this.state.items.push(itemObj)
        this.setState({items: this.state.items})
        this.props.handleSelectItem(itemObj);
    },

    refreshNav: function() {

    },

    render: function() {
        if(this.state.category == 'coupon' && this.state.items.length > 0) {
            var addButton = '';
        } else {
            var addButton = <a href="#" className="edit-aside-nav-add" onClick={this.addNavItem} ><h4>+ Add New {this.state.category} Type</h4> </a>
              
        }


        return (
            <ul className="editor-aside editor-aside-nav">
               
                {this.state.items.map(function(item, index){
                     return <EditorAsideNavItem currentItem={this.state.current_selection} key={index} item={item.item == undefined ? item: item.item} handleSelectEvent={this.props.handleSelectItem} handleRefreshNav={this.refreshNav} />
                 }.bind(this))} 
            
                {addButton}
              
            </ul>
        )
   } 
});
